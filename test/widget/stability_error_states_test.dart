import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/remote/content_gateway.dart';
import 'package:masti_gurukul/data/remote/remote_content.dart';
import 'package:masti_gurukul/data/repositories/sync_repository.dart';
import 'package:masti_gurukul/features/admin/admin_home_screen.dart';
import 'package:masti_gurukul/features/classes/classes_screen.dart';
import 'package:masti_gurukul/features/library/library_screen.dart';
import 'package:masti_gurukul/features/tests/tests_screen.dart';
import 'package:masti_gurukul/features/welcome/welcome_screen.dart';
import 'package:masti_gurukul/navigation/app_shell.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

/// A backend that behaves however each test needs: unreachable, refusing one
/// write, or healthy again. Stands in for the Supabase gateway so the failure
/// paths can be shown instead of argued about.
class _StubGateway implements ContentGateway {
  /// When true a read fails the way a dead network does. The real gateway does
  /// not wrap socket errors coming back from [fetchPublished], so neither does
  /// this one.
  bool readFails = false;

  /// When true a delete is refused, the way Row Level Security refuses a device
  /// that is not on the admin list.
  bool deleteFails = false;

  int readCalls = 0;
  final deletes = <String>[];

  final _changes = StreamController<String>.broadcast();

  @override
  Future<List<ContentRow>> fetchPublished(String table) async {
    readCalls++;
    if (readFails) {
      throw Exception('Failed host lookup: api.example.supabase.co');
    }
    return const [];
  }

  @override
  Future<List<ContentRow>> fetchAllForAdmin(String table) async => const [];

  @override
  Future<void> upsert(String table, ContentRow row) async {}

  @override
  Future<void> delete(String table, String id) async {
    if (deleteFails) {
      throw RemoteFailure(
        'The server refused to remove rows from the content tables. Row Level '
        'Security allows only the admin account.',
      );
    }
    deletes.add('$table/$id');
  }

  @override
  Future<String> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  }) async => 'https://bucket.example/library/$fileName';

  @override
  Stream<String> get changedTables => _changes.stream;

  /// One realtime event, the way a row inserted by the admin arrives.
  void emitChange(String table) => _changes.add(table);

  @override
  Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOutAdmin() async {}

  @override
  bool get isAdminSignedIn => true;

  @override
  String? get adminEmail => 'admin@example.com';

  @override
  Future<void> dispose() async {
    if (!_changes.isClosed) await _changes.close();
  }
}

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
  });

  tearDown(() async {
    state.dispose();
    // A test that imitates dead device storage closes this handle itself, and a
    // second close must not decide the test's verdict.
    try {
      await db.close();
    } on Object {
      // Already closed.
    }
  });

  /// Closes the local database so every read from it fails. That is what a
  /// phone with full storage, a corrupted file, or a cleared browser database
  /// looks like from inside a screen.
  Future<void> breakLocalStorage() async => db.close();

  Future<void> pumpShell(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: Scaffold(body: screen)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('local storage that cannot be read', () {
    testWidgets('the Library says so instead of building on a null', (
      tester,
    ) async {
      await state.startStudent(name: 'Asha', classId: 'class-10');
      await breakLocalStorage();

      await pumpScreen(tester, const LibraryScreen());

      expect(
        find.textContaining('The Library could not be read on this device'),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Try again'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await disposeTree(tester);
    });

    testWidgets('pressing Try again on a dead database stays honest', (
      tester,
    ) async {
      await state.startStudent(name: 'Asha', classId: 'class-10');
      await breakLocalStorage();
      await pumpScreen(tester, const LibraryScreen());

      await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('The Library could not be read on this device'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await disposeTree(tester);
    });

    testWidgets('the Classes tab says so instead of spinning forever', (
      tester,
    ) async {
      await state.startStudent(name: 'Asha', classId: 'class-10');
      await breakLocalStorage();

      await pumpScreen(tester, const ClassesScreen());

      expect(
        find.textContaining('Classes could not be read from this device'),
        findsOneWidget,
      );
      expect(find.text('Loading classes…'), findsNothing);
      expect(tester.takeException(), isNull);
      await disposeTree(tester);
    });

    testWidgets('the Tests tab retry does not throw back at the student', (
      tester,
    ) async {
      await state.startStudent(name: 'Asha', classId: 'class-9');
      await breakLocalStorage();

      await pumpScreen(tester, const TestsScreen());
      expect(
        find.textContaining('The published tests could not be loaded'),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.widgetWithText(FilledButton, 'Try again'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await disposeTree(tester);
    });
  });

  group('welcome screen', () {
    testWidgets('a failed first sign-in re-arms the only entrance', (
      tester,
    ) async {
      await breakLocalStorage();
      await pumpScreen(tester, const WelcomeScreen());

      await tester.ensureVisible(find.text('Start Learning'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Ankit Raj');
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('could not be saved on this device'),
        findsOneWidget,
      );
      // Pressable again: one bad write must not lock a student out of the app.
      expect(find.text('Start Learning'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
      await disposeTree(tester);
    });
  });

  group('sync engine', () {
    testWidgets('the offline badge appears when the server cannot be reached', (
      tester,
    ) async {
      final gateway = _StubGateway();
      state = AppState.withGateway(db, gateway);
      await state.startStudent(name: 'Rahul', classId: 'class-9');
      await pumpShell(tester);

      // Healthy: the badge says nothing, because silence is the normal state.
      expect(find.text('Offline'), findsNothing);

      gateway.readFails = true;
      await state.refreshContent();
      await tester.pumpAndSettle();

      expect(find.text('Offline'), findsOneWidget);
      expect(state.syncPhase, SyncPhase.offline);
      expect(tester.takeException(), isNull);

      // Tapping the badge is the retry, and a server that answers clears it.
      gateway.readFails = false;
      await tester.tap(find.text('Offline'));
      await tester.pumpAndSettle();

      expect(find.text('Offline'), findsNothing);
      expect(state.syncPhase, SyncPhase.idle);
      await disposeTree(tester);
    });

    testWidgets('a realtime change re-pulls without reopening the app', (
      tester,
    ) async {
      final gateway = _StubGateway();
      state = AppState.withGateway(db, gateway);
      await state.startStudent(name: 'Rahul', classId: 'class-9');
      await pumpShell(tester);

      await state.refreshContent();
      final before = gateway.readCalls;
      expect(before, greaterThan(0));

      gateway.emitChange('lessons');
      await tester.pump(const Duration(milliseconds: 600));
      // Still waiting: several row changes from one admin save cost one pull.
      expect(gateway.readCalls, before);

      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();
      expect(gateway.readCalls, greaterThan(before));
      await disposeTree(tester);
    });

    testWidgets('saved content stays readable while the server is gone', (
      tester,
    ) async {
      final gateway = _StubGateway()..readFails = true;
      state = AppState.withGateway(db, gateway);
      await state.startStudent(name: 'Rahul', classId: 'class-9');
      // Content that a sync before the outage already left on the device.
      await state.admin.saveChapter(
        subjectId: 'sub-class-9-mathematics',
        number: 1,
        title: 'Real Numbers',
      );
      await state.refreshContent();

      await pumpShell(tester);
      expect(find.text('Hello, Rahul 🙏'), findsOneWidget);

      await tapTab(tester, 'Classes');

      // The list on screen is still the one saved on the device, and the badge
      // says why it could not be updated.
      expect(find.text('Mathematics'), findsWidgets);
      expect(find.text('Offline'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // A pull that never reached the server must not have touched local rows.
      final chapters = await state.admin.chapters('sub-class-9-mathematics');
      expect(chapters.map((c) => c.title), contains('Real Numbers'));
      await disposeTree(tester);
    });
  });

  group('admin panel', () {
    testWidgets('a delete the server refuses is a message, not a crash', (
      tester,
    ) async {
      final gateway = _StubGateway();
      state = AppState.withGateway(db, gateway);
      final chapterId = await state.admin.saveChapter(
        subjectId: 'sub-class-10-mathematics',
        number: 1,
        title: 'Real Numbers',
      );
      await state.admin.saveLesson(
        chapterId: chapterId,
        title: 'Euclid stories',
        isPublished: true,
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const MaterialApp(home: AdminHomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Euclid stories'), findsOneWidget);

      gateway.deleteFails = true;
      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('The server refused to remove rows'),
        findsOneWidget,
      );
      // Nothing half-done: the row is still on this device and still listed.
      expect(find.text('Euclid stories'), findsOneWidget);
      expect(gateway.deletes, isEmpty);
      expect(tester.takeException(), isNull);

      // Let the confirmation retire so no timer outlives the test.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await disposeTree(tester);
    });
  });
}
