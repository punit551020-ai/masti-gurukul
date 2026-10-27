import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../local/database.dart';
import '../remote/content_gateway.dart';
import '../remote/remote_content.dart';

enum SyncPhase { idle, running, offline, failed }

/// Outcome of one pull, kept small on purpose: it is what the UI shows.
class SyncReport {
  SyncReport({required this.rowsApplied, required this.syncedAt, this.message});

  final int rowsApplied;
  final DateTime syncedAt;
  final String? message;
}

/// Mirrors the published backend content into the local drift database.
///
/// The device never reads content straight from the network: this pulls the
/// published rows once, keeps them locally, and refreshes them when the backend
/// reports a change. That is what makes a new YouTube link or PDF appear on a
/// student's phone without a rebuild, while the app still opens with no signal.
///
/// Local rows are never hard-deleted. A row that stops appearing in the
/// published feed is flipped to unpublished instead, because a student's
/// bookmarks, progress and downloaded files point at those ids, and deleting a
/// content row would either break a foreign key or quietly destroy their work.
class SyncRepository {
  SyncRepository(this._db, this._gateway) {
    _watchChanges();
  }

  final AppDatabase _db;
  final ContentGateway _gateway;
  final _status = StreamController<void>.broadcast();
  final _content = StreamController<void>.broadcast();
  Timer? _debounce;
  StreamSubscription<String>? _changes;
  bool _running = false;
  bool _againRequested = false;

  SyncPhase _phase = SyncPhase.idle;
  DateTime? _lastSyncedAt;
  String? _lastError;

  SyncPhase get phase => _phase;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  String? get lastError => _lastError;

  /// Fires when new content has actually landed in the local database, so a
  /// screen can reload without knowing anything about Supabase.
  Stream<void> get contentChanged => _content.stream;

  /// Fires when the sync status changes (started, finished, lost the network).
  /// Only used to repaint a status line.
  Stream<void> get statusChanged => _status.stream;

  Future<SyncReport?> pullAll() async {
    if (_running) {
      _againRequested = true;
      return null;
    }
    _running = true;
    _setPhase(SyncPhase.running);
    try {
      final report = await _pull();
      await _recordSuccess(report);
      _setPhase(SyncPhase.idle);
      return report;
    } on RemoteFailure catch (failure) {
      _fail(failure.message);
      return null;
    } on RemoteRowException catch (failure) {
      _fail(
        'The backend sent content this app cannot read: ${failure.message}',
      );
      return null;
    } catch (error) {
      _fail('$_unreachableMessage $_offlineHint');
      debugPrint('Sync failed: $error');
      return null;
    } finally {
      _running = false;
      if (_againRequested) {
        _againRequested = false;
        unawaited(pullAll());
      }
    }
  }

  Future<SyncReport> _pull() async {
    final order = RemoteTables.contentInDependencyOrder.reversed.toList();
    final fetched = await Future.wait(order.map(_gateway.fetchPublished));

    final byTable = <String, List<ContentRow>>{};
    for (var i = 0; i < order.length; i++) {
      byTable[order[i]] = fetched[i];
    }

    var applied = 0;
    await _db.transaction(() async {
      // Parents first: a child row inserted before its subject or chapter exists
      // would fail the foreign key.
      for (final table in order) {
        applied += await _applyTable(table, byTable[table] ?? const []);
      }
    });

    return SyncReport(rowsApplied: applied, syncedAt: DateTime.now());
  }

  Future<int> _applyTable(String table, List<ContentRow> rows) async {
    final servedIds = rows.map((row) => row['id'].toString()).toSet();
    var count = 0;
    for (final row in rows) {
      try {
        await _insert(table, row);
        count++;
      } on RemoteRowException {
        // One malformed admin row must not stop the whole catalog from syncing.
        debugPrint('Skipped a malformed $table row: ${row['id']}');
      }
    }
    await _retireMissing(table, servedIds);
    return count;
  }

  Future<void> _insert(String table, ContentRow row) {
    return switch (table) {
      RemoteTables.schoolClasses =>
        _db
            .into(_db.schoolClasses)
            .insertOnConflictUpdate(RemoteContent.schoolClass(row)),
      RemoteTables.boards =>
        _db.into(_db.boards).insertOnConflictUpdate(RemoteContent.board(row)),
      RemoteTables.subjects =>
        _db
            .into(_db.subjects)
            .insertOnConflictUpdate(RemoteContent.subject(row)),
      RemoteTables.chapters =>
        _db
            .into(_db.chapters)
            .insertOnConflictUpdate(RemoteContent.chapter(row)),
      RemoteTables.lessons =>
        _db.into(_db.lessons).insertOnConflictUpdate(RemoteContent.lesson(row)),
      RemoteTables.resources =>
        _db
            .into(_db.resources)
            .insertOnConflictUpdate(RemoteContent.resource(row)),
      RemoteTables.tests =>
        _db.into(_db.tests).insertOnConflictUpdate(RemoteContent.test(row)),
      RemoteTables.testQuestions =>
        _db
            .into(_db.testQuestions)
            .insertOnConflictUpdate(RemoteContent.question(row)),
      RemoteTables.liveClasses =>
        _db
            .into(_db.liveClasses)
            .insertOnConflictUpdate(RemoteContent.liveClass(row)),
      RemoteTables.announcements =>
        _db
            .into(_db.announcements)
            .insertOnConflictUpdate(RemoteContent.announcement(row)),
      _ => throw StateError('Table $table is not part of the synced catalog'),
    };
  }

  /// Hides local rows the backend no longer serves as published. Questions are
  /// left alone: they are only ever reachable through a published test.
  Future<void> _retireMissing(String table, Set<String> servedIds) async {
    switch (table) {
      case RemoteTables.lessons:
        await (_db.update(_db.lessons)..where(
              (t) => t.isPublished.equals(true) & t.id.isNotIn(servedIds),
            ))
            .write(const LessonsCompanion(isPublished: Value(false)));
      case RemoteTables.resources:
        await (_db.update(_db.resources)..where(
              (t) => t.isPublished.equals(true) & t.id.isNotIn(servedIds),
            ))
            .write(const ResourcesCompanion(isPublished: Value(false)));
      case RemoteTables.tests:
        await (_db.update(_db.tests)..where(
              (t) => t.isPublished.equals(true) & t.id.isNotIn(servedIds),
            ))
            .write(const TestsCompanion(isPublished: Value(false)));
      case RemoteTables.liveClasses:
        await (_db.update(_db.liveClasses)..where(
              (t) => t.isPublished.equals(true) & t.id.isNotIn(servedIds),
            ))
            .write(const LiveClassesCompanion(isPublished: Value(false)));
      case RemoteTables.announcements:
        await (_db.update(_db.announcements)
              ..where((t) => t.isActive.equals(true) & t.id.isNotIn(servedIds)))
            .write(const AnnouncementsCompanion(isActive: Value(false)));
      default:
        break;
    }
  }

  void _watchChanges() {
    _changes = _gateway.changedTables.listen((table) {
      _debounce?.cancel();
      _debounce = Timer(
        // The admin panel writes several rows per action; one refresh is enough.
        const Duration(milliseconds: 1200),
        () => unawaited(pullAll()),
      );
    });
  }

  Future<void> _recordSuccess(SyncReport report) async {
    _lastSyncedAt = report.syncedAt;
    _lastError = null;
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: 'last_synced_at',
            value: report.syncedAt.toUtc().toIso8601String(),
          ),
        );
    _content.add(null);
  }

  void _fail(String message) {
    _lastError = message;
    _setPhase(
      message.startsWith(_unreachableMessage)
          ? SyncPhase.offline
          : SyncPhase.failed,
    );
  }

  void _setPhase(SyncPhase phase) {
    if (_phase == phase) return;
    _phase = phase;
    _status.add(null);
  }

  static const _unreachableMessage = 'Could not reach the backend.';
  static const _offlineHint =
      'Showing the content already saved on this device.';

  Future<void> dispose() async {
    // Unhook the gateway stream first: a realtime event arriving after the
    // controllers below close would restart the debounce timer and throw when
    // the finished pull tried to announce itself.
    await _changes?.cancel();
    _changes = null;
    _debounce?.cancel();
    await _status.close();
    await _content.close();
  }
}
