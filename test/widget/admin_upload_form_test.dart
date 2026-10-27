import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/features/admin/admin_forms.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

/// The owner's own words: only the title should be compulsory, and the year box
/// was confusing enough to remove. These tests drive the real bottom sheets so
/// the forms cannot quietly grow a required field back.
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

  /// Opens one of the admin sheets over a tree that has the app state in it.
  Future<void> open(
    WidgetTester tester,
    Future<void> Function(BuildContext) show,
  ) async {
    // A tall screen so every field of a sheet is on it at once.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    BuildContext? found;
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                found = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
    final context = found!;
    // The returned future only completes when the sheet closes, so it is
    // deliberately left unawaited here.
    show(context);
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String label, String value) async {
    final field = find.widgetWithText(TextFormField, label);
    expect(field, findsOneWidget, reason: 'no field labelled $label');
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<void> press(WidgetTester tester, String button) async {
    await tester.ensureVisible(find.widgetWithText(FilledButton, button));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, button));
    await tester.pumpAndSettle();
  }

  group('the file form', () {
    testWidgets('has no year box any more', (tester) async {
      await open(
        tester,
        (context) => showResourceForm(
          context,
          subjectId: 'sub-class-10-science',
          filesUnder: 'Class 10 · Bihar Board · Science',
          onSaved: () {},
        ),
      );

      expect(find.text('Year label (optional)'), findsNothing);
      expect(find.text('Title'), findsOneWidget);
      expect(
        find.text('Only the title is needed. Everything else can stay empty.'),
        findsOneWidget,
      );
      // The owner has to see where the file lands, or a handout ends up in a
      // subject nobody opens.
      expect(
        find.text('Files under: Class 10 · Bihar Board · Science'),
        findsOneWidget,
      );
      await disposeTree(tester);
    });

    testWidgets('saves with nothing but a title', (tester) async {
      await open(
        tester,
        (context) => showResourceForm(
          context,
          subjectId: 'sub-class-10-science',
          filesUnder: 'Class 10 · Bihar Board · Science',
          onSaved: () {},
        ),
      );

      // An empty title is still refused, and says so instead of crashing.
      await press(tester, 'Save file');
      expect(find.text('Title is required.'), findsOneWidget);

      await type(tester, 'Title', 'Midterm worksheet');
      await press(tester, 'Save file');

      // The sheet went away, so the save went through.
      expect(find.byType(TextFormField), findsNothing);
      // Read with the admin's own list: a student-facing read only ever shows
      // published rows.
      final rows = await state.admin.resources();
      expect(rows.map((r) => r.title), ['Midterm worksheet']);
      final saved = rows.single;
      expect(saved.kind, ResourceKinds.pdf);
      // Nothing was attached and no link was typed, and that is allowed now.
      expect(saved.remoteUrl, isNull);
      expect(saved.localFilePath, isNull);
      expect(saved.yearLabel, isNull);
      // A draft stays a draft until the owner turns Published on.
      expect(saved.isPublished, isFalse);
      await disposeTree(tester);
    });

    testWidgets('an edit keeps the year the row already had', (tester) async {
      final id = await state.admin.saveResource(
        subjectId: 'sub-class-10-science',
        title: 'Old paper',
        kind: ResourceKinds.previousYearPaper,
        yearLabel: 2019,
        remoteUrl: 'https://bucket.example/library/2019.pdf',
      );
      final before = await state.admin.resources();
      final existing = before.firstWhere((r) => r.id == id);

      await open(
        tester,
        (context) => showResourceForm(
          context,
          subjectId: 'sub-class-10-science',
          filesUnder: 'Class 10 · Bihar Board · Science',
          existing: existing,
          onSaved: () {},
        ),
      );

      expect(find.text('Year label (optional)'), findsNothing);
      await type(tester, 'Title', '2019 paper');
      await press(tester, 'Save file');

      final after = await state.admin.resources();
      expect(after.firstWhere((r) => r.id == id).yearLabel, 2019);
      await disposeTree(tester);
    });
  });

  group('the chapter form', () {
    testWidgets('takes the next number when the box is left empty', (
      tester,
    ) async {
      await open(
        tester,
        (context) => showChapterForm(
          context,
          subjectId: 'sub-class-10-science',
          filesUnder: 'Class 10 · Bihar Board · Science',
          nextNumber: 4,
          onSaved: () {},
        ),
      );

      await press(tester, 'Save chapter');
      expect(find.text('Chapter title is required.'), findsOneWidget);

      await type(tester, 'Title', 'Polynomials');
      await press(tester, 'Save chapter');

      final chapters = await state.catalog.chaptersForSubject(
        'sub-class-10-science',
      );
      expect(chapters.single.number, 4);
      expect(chapters.single.title, 'Polynomials');
      await disposeTree(tester);
    });

    testWidgets('says which subject the chapter is filed under', (
      tester,
    ) async {
      await open(
        tester,
        (context) => showChapterForm(
          context,
          subjectId: 'sub-class-10-social-science',
          filesUnder: 'Class 10 · Bihar Board · Social Science',
          onSaved: () {},
        ),
      );

      expect(
        find.text('Files under: Class 10 · Bihar Board · Social Science'),
        findsOneWidget,
      );
      // A brand-new chapter has nowhere to move from, so no picker yet.
      expect(find.text('Move this to another subject'), findsNothing);
      await disposeTree(tester);
    });

    testWidgets('moves a mis-filed chapter to the right subject', (
      tester,
    ) async {
      // The real mistake this guards against: a Geography chapter saved inside
      // Mathematics, which the owner could previously only fix with SQL.
      final chapterId = await state.admin.saveChapter(
        subjectId: 'sub-class-10-mathematics',
        number: 1,
        title: 'Disaster Management',
      );
      await state.admin.saveLesson(
        chapterId: chapterId,
        title: 'Disaster Management one shot',
        youtubeUrl: 'https://youtu.be/mhBL8HkY0I4',
        isPublished: true,
      );
      final chapter = await state.catalog.chapterById(chapterId);

      final subjects = await state.catalog.subjectsForClass('class-10');
      await open(
        tester,
        (context) => showChapterForm(
          context,
          subjectId: 'sub-class-10-mathematics',
          filesUnder: 'Class 10 · Bihar Board · Mathematics',
          subjectChoices: [
            for (final s in subjects)
              AdminSubjectChoice(id: s.id, label: s.nameEnglish),
          ],
          existing: chapter,
          onSaved: () {},
        ),
      );

      expect(find.text('Move this to another subject'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Social Science'));
      await tester.pumpAndSettle();

      await press(tester, 'Save chapter');

      expect(
        (await state.catalog.chaptersForSubject('sub-class-10-mathematics'))
            .where((c) => c.id == chapterId),
        isEmpty,
      );
      final moved = await state.catalog.videoLessons(
        subjectId: 'sub-class-10-social-science',
      );
      expect(moved.map((v) => v.lesson.title), [
        'Disaster Management one shot',
      ]);
      await disposeTree(tester);
    });
  });

  group('the test form', () {
    testWidgets('clearing the number boxes keeps the usual values', (
      tester,
    ) async {
      await state.admin.saveChapter(
        subjectId: 'sub-class-10-science',
        number: 1,
        title: 'Real Numbers',
      );

      final chapters = await state.admin.chapters('sub-class-10-science');
      await open(
        tester,
        (context) => showTestForm(context, chapters: chapters, onSaved: () {}),
      );

      await type(tester, 'Time limit (optional)', '');
      await type(tester, 'Marks per question (optional)', '');
      await type(tester, 'Negative marking per wrong answer (optional)', '');
      await type(tester, 'Title', 'Irrational numbers quiz');
      await press(tester, 'Save test');

      final tests = await state.admin.tests();
      expect(tests.single.title, 'Irrational numbers quiz');
      expect(tests.single.timeLimitMinutes, 20);
      expect(tests.single.marksPerQuestion, 1);
      expect(tests.single.negativeMarking, 0);
      await disposeTree(tester);
    });

    testWidgets('a nonsense number is refused with a readable reason', (
      tester,
    ) async {
      await state.admin.saveChapter(
        subjectId: 'sub-class-10-science',
        number: 1,
        title: 'Real Numbers',
      );

      final chapters = await state.admin.chapters('sub-class-10-science');
      await open(
        tester,
        (context) => showTestForm(context, chapters: chapters, onSaved: () {}),
      );

      await type(tester, 'Title', 'Too long');
      await type(tester, 'Time limit (optional)', '900');
      await press(tester, 'Save test');

      expect(
        find.textContaining('Time limit must be between 1 and 300'),
        findsOneWidget,
      );
      expect(await state.admin.tests(), isEmpty);
      await disposeTree(tester);
    });
  });
}
