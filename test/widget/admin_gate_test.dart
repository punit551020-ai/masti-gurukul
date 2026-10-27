import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/config/backend_config.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/remote/content_gateway.dart';
import 'package:masti_gurukul/data/remote/remote_content.dart';
import 'package:masti_gurukul/features/admin/admin_gate.dart';
import 'package:masti_gurukul/features/admin/admin_home_screen.dart';
import 'package:masti_gurukul/navigation/app_shell.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

/// The admin sign-in flow, end to end, against a fake gateway.
///
/// `test/widget/app_shell_test.dart` proves the gate *refuses* to open when no
/// backend is compiled in. These tests cover the other half, which is the half
/// that matters for security: the form really appears, the typed credentials
/// really go to the server, and the panel really stays shut when the server says
/// no. Nothing reaches Supabase - the fake gateway answers locally, so no
/// password is sent anywhere by a test.
///
/// They need a build carrying `SUPABASE_URL` and `SUPABASE_ANON_KEY`, because
/// [AdminGate] reads them at compile time:
///
///   flutter test --dart-define-from-file=.env test/widget/admin_gate_test.dart
///
/// Without those defines the gate would legitimately refuse to show a sign-in
/// form, and these tests would be describing the wrong build, so they skip.
void main() {
  final backendBuilt = BackendConfig.isUsable;
  late AppDatabase db;
  late _FakeGateway gateway;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    gateway = _FakeGateway();
    state = AppState.withGateway(db, gateway);
    await state.catalog.seedStructureIfEmpty();
    await state.startStudent(name: 'Rahul', classId: 'class-9');
    // The gate counts failures for the whole process, so each test starts with a
    // clean slate - otherwise one rejected password in an earlier test would
    // quietly shorten the cool-down in a later one.
    AdminGate.resetForTesting();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: const AppShell()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Asks for the panel exactly the way the logo's triple tap does. The entrance
  /// itself - three taps in the drawer header, and nothing else anywhere - is
  /// what `app_shell_test.dart` pins; here the gate's own behaviour is.
  Future<void> openGate(WidgetTester tester) async {
    await pumpApp(tester);
    // The gate awaits the dialog itself, so the test must not await it here.
    unawaited(AdminGate.request(tester.element(find.byType(AppShell))));
    await tester.pumpAndSettle();
  }

  Future<void> submitSignIn(
    WidgetTester tester, {
    String email = 'admin@example.com',
    String password = 'hunter2',
  }) async {
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), email);
    await tester.enterText(fields.at(1), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
  }

  Future<void> cancelSignIn(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
  }

  testWidgets('asking for the panel shows the sign-in form, not the panel', (
    tester,
  ) async {
    await openGate(tester);

    // The triple tap only *finds* the door. What opens the panel is a session
    // the server agrees belongs to an allow-listed admin.
    expect(find.text('Admin sign in'), findsOneWidget);
    expect(find.byType(AdminHomeScreen), findsNothing);
    expect(gateway.signInAttempts, isEmpty);
  }, skip: !backendBuilt);

  testWidgets(
    'what the admin typed goes to the backend, trimmed, and the backend decides',
    (tester) async {
      await openGate(tester);
      await submitSignIn(
        tester,
        email: '  admin@example.com  ',
        password: 'hunter2',
      );

      expect(gateway.signInAttempts, hasLength(1));
      expect(gateway.signInAttempts.single.email, 'admin@example.com');
      expect(gateway.signInAttempts.single.password, 'hunter2');
      expect(find.byType(AdminHomeScreen), findsOneWidget);
    },
    skip: !backendBuilt,
  );

  testWidgets('a password the server rejects keeps the panel closed', (
    tester,
  ) async {
    gateway.rejectWith = 'Invalid login credentials';
    await openGate(tester);
    await submitSignIn(tester, email: 'someone@example.com', password: 'wrong');

    // The student-facing wording stays honest about who refused: the server,
    // not the app.
    expect(find.textContaining('not accepted'), findsOneWidget);
    expect(find.textContaining('Invalid login credentials'), findsOneWidget);
    expect(find.byType(AdminHomeScreen), findsNothing);
  }, skip: !backendBuilt);

  testWidgets('a blank email or password is never sent', (tester) async {
    await openGate(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text('Enter both the admin email and password.'),
      findsOneWidget,
    );
    expect(gateway.signInAttempts, isEmpty);
  }, skip: !backendBuilt);

  testWidgets('an already signed-in admin is not asked again', (tester) async {
    gateway.signedIn = true;
    await openGate(tester);

    expect(find.byType(AdminHomeScreen), findsOneWidget);
    expect(find.text('Admin sign in'), findsNothing);
  }, skip: !backendBuilt);

  testWidgets('five rejected tries lock the door before a sixth is sent', (
    tester,
  ) async {
    gateway.rejectWith = 'Invalid login credentials';
    await pumpApp(tester);
    final context = tester.element(find.byType(AppShell));

    for (var tryNumber = 1; tryNumber <= 6; tryNumber++) {
      unawaited(AdminGate.request(context));
      await tester.pumpAndSettle();
      // The gate stops asking the server once the counter is full, so the form
      // disappearing is the signal that the lock-out kicked in.
      if (find.text('Admin sign in').evaluate().isEmpty) break;
      await submitSignIn(tester, email: 'someone@example.com', password: 'x');
      await cancelSignIn(tester);
    }

    // Exactly five attempts reach the server per app run, and the sixth ask is
    // answered by the lock-out itself. This is a speed bump, not a wall: the
    // counter lives in memory, so a restart clears it. What actually stops a
    // guessed password is Supabase's own rate limiting plus the server-side
    // admin allow-list that `SupabaseContentGateway.signInAdmin` now checks.
    expect(gateway.signInAttempts, hasLength(5));
    expect(find.textContaining('Too many failed attempts'), findsOneWidget);
  }, skip: !backendBuilt);
}

class _FakeGateway implements ContentGateway {
  final signInAttempts = <_Creds>[];
  bool signedIn = false;

  /// When set, every sign-in is refused with this server message.
  String? rejectWith;

  @override
  Future<List<ContentRow>> fetchPublished(String table) async => const [];

  @override
  Future<List<ContentRow>> fetchAllForAdmin(String table) async => const [];

  @override
  Future<void> upsert(String table, ContentRow row) async {}

  @override
  Future<void> delete(String table, String id) async {}

  @override
  Future<String> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  }) async => 'https://fake.invalid/$fileName';

  @override
  Stream<String> get changedTables => const Stream.empty();

  @override
  Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {
    signInAttempts.add(_Creds(email: email, password: password));
    final rejection = rejectWith;
    if (rejection != null) {
      throw AdminSignInFailure(
        'That email and password were not accepted. $rejection',
      );
    }
    signedIn = true;
  }

  @override
  Future<void> signOutAdmin() async => signedIn = false;

  @override
  bool get isAdminSignedIn => signedIn;

  @override
  String? get adminEmail => signedIn ? 'admin@example.com' : null;

  @override
  Future<void> dispose() async {}
}

class _Creds {
  _Creds({required this.email, required this.password});

  final String email;
  final String password;
}
