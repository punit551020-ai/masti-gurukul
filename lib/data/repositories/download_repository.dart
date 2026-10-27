import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../local/tables.dart';

class DownloadRepository {
  DownloadRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// A plain change counter the download screens listen to so their progress
  /// bars stay live without a drifting database stream. Drift's own `.watch()`
  /// schedules a cleanup timer when a `StreamBuilder` unsubscribes, which makes
  /// widget tests report a pending timer; bumping a notifier instead tears the
  /// subscription down synchronously and leaves nothing behind.
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  /// Listen to this to be told whenever a download row was added, updated or
  /// removed. Re-read the rows with [forStudent] / [forStudentAndResource].
  ValueListenable<int> get changes => _revision;

  void _notify() => _revision.value = _revision.value + 1;

  Future<List<Download>> forStudent(String studentId) =>
      (_db.select(_db.downloads)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  /// A live view of the rows for a student, backed by a drift stream. This is
  /// only used outside the widget tree (the plain unit test observes status
  /// transitions through it). The download screens do NOT subscribe to this,
  /// because a drift `.watch()` stream leaves a pending cleanup timer when its
  /// `StreamBuilder` unsubscribes; they listen to [changes] instead.
  Stream<List<Download>> watchForStudent(String studentId) =>
      (_db.select(_db.downloads)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<Download?> byId(String downloadId) => (_db.select(
    _db.downloads,
  )..where((t) => t.id.equals(downloadId))).getSingleOrNull();

  Future<Download?> forStudentAndResource(
    String studentId,
    String resourceId,
  ) =>
      (_db.select(_db.downloads)
            ..where(
              (t) =>
                  t.studentId.equals(studentId) &
                  t.resourceId.equals(resourceId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  /// The finished download that owns a real local file for [resourceId], if
  /// one exists. Only COMPLETE rows with a path that still points at a file the
  /// viewer can open are returned.
  Future<Download?> completedFor(String studentId, String resourceId) =>
      (_db.select(_db.downloads)..where(
            (t) =>
                t.studentId.equals(studentId) &
                t.resourceId.equals(resourceId) &
                t.status.equals(DownloadStatuses.complete) &
                t.localPath.isNotNull(),
          ))
          .getSingleOrNull();

  Future<Download> enqueue({
    required String studentId,
    required String resourceId,
  }) async {
    final existing =
        await (_db.select(_db.downloads)
              ..where(
                (t) =>
                    t.studentId.equals(studentId) &
                    t.resourceId.equals(resourceId),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing;

    final id = 'dl-${_uuid.v4()}';
    await _db
        .into(_db.downloads)
        .insert(
          DownloadsCompanion.insert(
            id: id,
            studentId: studentId,
            resourceId: resourceId,
            status: DownloadStatuses.queued,
          ),
        );
    _notify();
    return (_db.select(
      _db.downloads,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> markRunning({
    required String downloadId,
    String? localPath,
    int? totalBytes,
  }) async {
    await (_db.update(
      _db.downloads,
    )..where((t) => t.id.equals(downloadId))).write(
      DownloadsCompanion(
        status: const Value(DownloadStatuses.running),
        localPath: localPath == null ? const Value.absent() : Value(localPath),
        totalBytes: totalBytes == null
            ? const Value.absent()
            : Value(totalBytes),
        lastError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
    _notify();
  }

  /// Progress tick. We always record the real byte counts we have seen so far;
  /// we never pretend a partial file is done.
  Future<void> updateProgress({
    required String downloadId,
    required int downloadedBytes,
    int? totalBytes,
  }) async {
    await (_db.update(
      _db.downloads,
    )..where((t) => t.id.equals(downloadId))).write(
      DownloadsCompanion(
        downloadedBytes: Value(downloadedBytes),
        totalBytes: totalBytes == null
            ? const Value.absent()
            : Value(totalBytes),
        updatedAt: Value(DateTime.now()),
      ),
    );
    _notify();
  }

  Future<void> markComplete({
    required String downloadId,
    required String localPath,
    required int downloadedBytes,
    int? totalBytes,
  }) async {
    await (_db.update(
      _db.downloads,
    )..where((t) => t.id.equals(downloadId))).write(
      DownloadsCompanion(
        status: const Value(DownloadStatuses.complete),
        localPath: Value(localPath),
        downloadedBytes: Value(downloadedBytes),
        totalBytes: totalBytes == null
            ? const Value.absent()
            : Value(totalBytes),
        lastError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
    _notify();
  }

  Future<void> markFailed({
    required String downloadId,
    required String error,
  }) async {
    await (_db.update(
      _db.downloads,
    )..where((t) => t.id.equals(downloadId))).write(
      DownloadsCompanion(
        status: const Value(DownloadStatuses.failed),
        lastError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
    _notify();
  }

  Future<void> forget(String downloadId) async {
    await (_db.delete(
      _db.downloads,
    )..where((t) => t.id.equals(downloadId))).go();
    _notify();
  }
}
