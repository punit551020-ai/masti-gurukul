import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/features/admin/admin_gate.dart';
import 'package:masti_gurukul/features/admin/admin_home_screen.dart';
import 'package:masti_gurukul/features/admin/hidden_trigger.dart';
import 'package:masti_gurukul/features/welcome/welcome_screen.dart';
import 'package:masti_gurukul/main.dart' show MastiGurukulApp;
import 'package:masti_gurukul/navigation/app_shell.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

final _devanagari = RegExp(r'[ऀ-ॿ]');

Finder _hindiTexts() => find.byWidgetPredicate(
  (widget) =>
      widget is Text &&
      widget.data != null &&
      _devanagari.hasMatch(widget.data!),
);

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
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

  testWidgets('classes are seeded and shown on home', (tester) async {
    await state.startStudent(name: 'Rahul', classId: 'class-10');
    await pumpApp(tester);

    expect(find.text('Hello, Rahul 🙏'), findsOneWidget);
    for (final label in [
      'Class 6',
      'Class 7',
      'Class 8',
      'Class 9',
      'Class 10',
    ]) {
      expect(find.text(label), findsWidgets, reason: '$label missing');
    }
    await disposeTree(tester);
  });

  testWidgets('choosing a class reveals its subjects', (tester) async {
    await state.startStudent(name: 'Rahul');
    await pumpApp(tester);

    expect(find.text('Choose your class first.'), findsOneWidget);

    await state.setSelectedClassId('class-9');
    await tester.pumpAndSettle();

    expect(find.text('Mathematics'), findsWidgets);
    expect(find.text('Science'), findsWidgets);
    await disposeTree(tester);
  });

  testWidgets('subject with no content shows an honest empty state', (
    tester,
  ) async {
    await state.startStudent(name: 'Rahul', classId: 'class-8');
    await pumpApp(tester);

    await tester.tap(find.text('Mathematics').first);
    await tester.pumpAndSettle();

    expect(find.text('Nothing published yet'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('every visible label is English', (tester) async {
    await state.startStudent(name: 'Rahul', classId: 'class-9');
    await pumpApp(tester);

    expect(_hindiTexts(), findsNothing);

    for (var i = 1; i < primaryTabs.length; i++) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(primaryTabs[i].tabLabel),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        _hindiTexts(),
        findsNothing,
        reason: '${primaryTabs[i].label} has Hindi text',
      );
    }

    for (final item in drawerItems) {
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(Drawer),
          matching: find.text(item.label),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        _hindiTexts(),
        findsNothing,
        reason: '${item.label} has Hindi text',
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    await disposeTree(tester);
  });

  testWidgets('five tabs still fit a phone screen', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await state.startStudent(name: 'Rahul', classId: 'class-9');
    await pumpApp(tester);

    expect(primaryTabs, hasLength(5));
    // No AI tutor any more, and a student must never be able to reach one by
    // accident - the name is checked here so the tab cannot creep back in.
    expect(
      primaryTabs.map((tab) => tab.label),
      isNot(contains('Hacker Ankit AI')),
    );
    expect(primaryTabs.map((tab) => tab.tabLabel), isNot(contains('AI Tutor')));
    // A long label in a five-slot bar would overflow and paint the red/yellow
    // stripes the owner complained about, so the bottom bar uses short labels.
    for (final tab in primaryTabs) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(tab.tabLabel),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${tab.label} overflows');
    }
    await disposeTree(tester);
  });

  testWidgets(
    'triple tap on the logo does not open the admin panel without a backend',
    (tester) async {
      await state.startStudent(name: 'Rahul', classId: 'class-9');
      await pumpApp(tester);

      expect(find.byType(AdminHomeScreen), findsNothing);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      final logo = find.byType(HiddenAdminTrigger);
      await tester.tap(logo);
      await tester.tap(logo);
      await tester.pumpAndSettle();
      expect(find.byType(AdminHomeScreen), findsNothing);

      await tester.tap(logo);
      await tester.pumpAndSettle();

      // The gate signs in against the backend. With none configured it must
      // refuse to open and explain itself instead of showing a sign-in form.
      expect(find.byType(AdminHomeScreen), findsNothing);
      expect(find.text('Admin sign in'), findsNothing);
      expect(find.textContaining('No backend is configured'), findsOneWidget);
      await disposeTree(tester);
    },
  );

  testWidgets('AdminGate.request without a backend only explains itself', (
    tester,
  ) async {
    await state.startStudent(name: 'Rahul', classId: 'class-9');
    await pumpApp(tester);

    await AdminGate.request(tester.element(find.byType(AppShell)));
    await tester.pumpAndSettle();

    expect(find.byType(AdminHomeScreen), findsNothing);
    expect(find.text('Admin sign in'), findsNothing);
    expect(find.textContaining('admin panel is closed'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('Tests tab lists a saved test and opens its question manager', (
    tester,
  ) async {
    await state.startStudent(name: 'Rahul', classId: 'class-9');
    final subjects = await state.catalog.subjectsForClass('class-9');
    final chapterId = await state.admin.saveChapter(
      subjectId: subjects.first.id,
      number: 1,
      title: 'Real Numbers',
    );
    final testId = await state.admin.saveTest(
      chapterId: chapterId,
      title: 'Number line check',
      timeLimitMinutes: 25,
      marksPerQuestion: 2,
    );
    await state.admin.saveQuestion(
      testId: testId,
      prompt: 'Which is the smallest?',
      optionA: '-3',
      optionB: '0',
      optionC: '3',
      optionD: '1',
      correctOption: 'A',
      marks: 2,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: const AdminHomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // The tab bar is scrollable, so 'Tests' can sit off-screen in the test
    // viewport; scroll it into view before tapping or the tap lands elsewhere.
    await tester.ensureVisible(find.text('Tests'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tests'));
    await tester.pumpAndSettle();

    // The panel opens on the last class (Class 10), which has no chapters.
    expect(find.textContaining('No chapters yet'), findsOneWidget);

    await tester.tap(find.text('Class 10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Class 9'));
    await tester.pumpAndSettle();

    expect(find.text('1. Real Numbers'), findsOneWidget);
    expect(find.text('Number line check'), findsOneWidget);
    expect(find.text('1 question • 2 marks • 25 min'), findsOneWidget);

    // Tapping the test opens its questions.
    await tester.tap(find.text('Number line check'));
    await tester.pumpAndSettle();
    expect(find.text('Questions'), findsOneWidget);
    expect(find.text('Which is the smallest?'), findsOneWidget);
    expect(find.textContaining('Answer A'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('the panel offers "All Classes" and files content there', (
    tester,
  ) async {
    final subjectId = await state.admin.saveSubject(
      classId: ClassIds.all,
      nameEnglish: 'Olympiad prep',
    );
    await state.admin.saveResource(
      subjectId: subjectId,
      title: 'Trick sheet',
      kind: ResourceKinds.pdf,
      remoteUrl: 'https://files.example.com/trick.pdf',
      isPublished: true,
    );

    // A title-only save is allowed now, and the panel marks such a row itself.
    await state.admin.saveResource(
      subjectId: subjectId,
      title: 'Pending sheet',
      kind: ResourceKinds.notes,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: const AdminHomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // The panel still opens on a real class, so a normal upload cannot quietly
    // land in the shared one.
    expect(find.text('Class 10'), findsOneWidget);
    await tester.tap(find.text('Class 10'));
    await tester.pumpAndSettle();
    expect(find.text('All Classes'), findsOneWidget);

    await tester.tap(find.text('All Classes'));
    await tester.pumpAndSettle();

    // The subject list now holds the shared subject, and its file with it.
    expect(find.text('Olympiad prep'), findsWidgets);
    await tester.ensureVisible(find.text('Files'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Files'));
    await tester.pumpAndSettle();
    expect(find.text('Trick sheet'), findsOneWidget);
    expect(
      find.textContaining('no file attached yet'),
      findsOneWidget,
      reason: 'a title-only row must say it has no file',
    );
    await disposeTree(tester);
  });

  test('profile name persists in the database', () async {
    await state.startStudent(name: 'Sita', classId: 'class-6');
    final stored = await state.students.currentStudent();
    expect(stored, isNotNull);
    expect(stored!.displayName, 'Sita');
    expect(stored.classId, 'class-6');

    await state.updateProfile(displayName: 'Sita Sharma');
    final after = await state.students.currentStudent();
    expect(after!.displayName, 'Sita Sharma');
  });

  testWidgets('editing the name on the Profile tab rewrites the greeting', (
    tester,
  ) async {
    await state.startStudent(name: 'Rahul', classId: 'class-10');
    await pumpApp(tester);
    expect(find.text('Hello, Rahul 🙏'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Display name'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Ankit Raj');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save name'));
    await tester.pumpAndSettle();

    expect(find.textContaining('name updated'), findsOneWidget);
    // Let the confirmation retire so no timer outlives the test.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Ankit Raj 🙏'), findsOneWidget);
    expect(find.text('Home · Ankit Raj'), findsOneWidget);

    final stored = await state.students.currentStudent();
    expect(stored!.displayName, 'Ankit Raj');
    await disposeTree(tester);
  });

  testWidgets('the editor refuses a name the welcome screen would refuse', (
    tester,
  ) async {
    await state.startStudent(name: 'Rahul');
    await pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '7');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save name'));
    await tester.pumpAndSettle();

    expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    // Still open, and the stored name untouched.
    expect(find.text('Edit profile'), findsOneWidget);
    final stored = await state.students.currentStudent();
    expect(stored!.displayName, 'Rahul');

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Edit profile'), findsNothing);
    await disposeTree(tester);
  });

  testWidgets('signing out opens the Welcome screen and keeps the profile', (
    tester,
  ) async {
    await state.startStudent(name: 'Ankit Raj', classId: 'class-10');
    final signedIn = await state.students.currentStudent();
    expect(signedIn, isNotNull);

    // The production widget, not a copy of its routing: the Welcome-versus-
    // Home decision lives in MastiGurukulApp and has to be the real one.
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MastiGurukulApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('Hello, Ankit Raj 🙏'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Sign out'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);
    expect(state.currentStudent, isNull);
    expect(await state.students.currentStudentId(), isNull);

    // Nothing deleted: the row is still on the device, only the signed-in
    // marker is gone.
    expect(await state.students.studentById(signedIn!.id), isNotNull);
    await disposeTree(tester);
  });
}
