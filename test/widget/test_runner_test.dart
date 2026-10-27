import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/repositories/test_repository.dart';
import 'package:masti_gurukul/features/tests/test_runner_screen.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

const _q1Prompt = 'Which of these is a prime number?';
const _q2Prompt = 'What is 3 x 4?';
const _q3Prompt = 'What is the smallest counting number?';

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
    await state.startStudent(name: 'Asha', classId: 'class-10');
  });

  tearDown(() async {
    await db.close();
  });

  /// Creates a published 3-question test through the admin repository and
  /// returns the stored [Test] row.
  Future<Test> createPublishedTest({
    required String title,
    required int timeLimitMinutes,
    required double negativeMarking,
  }) async {
    final chapterId = await state.admin.saveChapter(
      subjectId: 'sub-class-10-mathematics',
      number: 1,
      title: 'Number System',
    );
    final testId = await state.admin.saveTest(
      chapterId: chapterId,
      title: title,
      timeLimitMinutes: timeLimitMinutes,
      marksPerQuestion: 1,
      negativeMarking: negativeMarking,
      isPublished: true,
    );
    await state.admin.saveQuestion(
      testId: testId,
      prompt: _q1Prompt,
      optionA: 'Two',
      optionB: 'Four',
      optionC: 'Six',
      optionD: 'Nine',
      correctOption: 'A',
      explanation: 'Two has exactly two factors: one and itself.',
      marks: 1,
      displayOrder: 0,
    );
    await state.admin.saveQuestion(
      testId: testId,
      prompt: _q2Prompt,
      optionA: 'Ten',
      optionB: 'Twelve',
      optionC: 'Fourteen',
      optionD: 'Fifteen',
      correctOption: 'B',
      marks: 1,
      displayOrder: 1,
    );
    await state.admin.saveQuestion(
      testId: testId,
      prompt: _q3Prompt,
      optionA: 'Zero',
      optionB: 'One',
      optionC: 'Two',
      optionD: 'Ten',
      correctOption: 'B',
      marks: 1,
      displayOrder: 2,
    );
    return await (db.select(
      db.tests,
    )..where((t) => t.id.equals(testId))).getSingle();
  }

  Future<void> pumpRunner(WidgetTester tester, Test test) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: TestRunnerScreen(testId: test.id)),
      ),
    );
    // Questions arrive through several async database reads. Pump without a
    // duration so the fake clock (and therefore the countdown) does not move.
    for (var i = 0; i < 10 && !tester.any(find.text(_q1Prompt)); i++) {
      await tester.pump();
    }
    expect(find.text(_q1Prompt), findsOneWidget);
  }

  testWidgets('full attempt: answer, review-flag, submit, persist, review', (
    tester,
  ) async {
    final test = await createPublishedTest(
      title: 'Number System Test',
      timeLimitMinutes: 5,
      negativeMarking: 0.25,
    );
    await pumpRunner(tester, test);

    expect(find.text('Question 1 of 3'), findsOneWidget);
    expect(find.text('Time left 05:00'), findsOneWidget);

    // Q1: pick the correct option A.
    await tester.tap(find.byKey(const Key('option-A')));
    await tester.pump();
    expect(find.text('Clear response'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('option-A')),
        matching: find.byIcon(Icons.check_circle_rounded),
      ),
      findsOneWidget,
    );

    // Q2 via the palette: pick the wrong option A.
    await tester.ensureVisible(find.byKey(const Key('palette-1')));
    await tester.tap(find.byKey(const Key('palette-1')));
    await tester.pump();
    expect(find.text(_q2Prompt), findsOneWidget);
    await tester.tap(find.byKey(const Key('option-A')));
    await tester.pump();

    // Q3 via the palette: leave unanswered but mark it for review.
    await tester.ensureVisible(find.byKey(const Key('palette-2')));
    await tester.tap(find.byKey(const Key('palette-2')));
    await tester.pump();
    expect(find.text(_q3Prompt), findsOneWidget);
    await tester.tap(find.byKey(const Key('mark-review')));
    await tester.pump();
    expect(find.text('Remove review flag'), findsOneWidget);

    // Submit shows a confirmation that counts the unanswered question.
    await tester.tap(find.byKey(const Key('submit-test')));
    await tester.pump();
    expect(find.text('Submit test?'), findsOneWidget);
    expect(
      find.textContaining('1 of 3 questions is still unanswered'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('submit-confirm')));
    await tester.pump();
    await tester.pumpAndSettle();

    // Result screen: +1 for Q1, -0.25 for Q2, Q3 untouched.
    expect(find.text('Test result'), findsOneWidget);
    expect(find.text('0.75 / 3'), findsOneWidget);
    expect(find.text('25% score'), findsOneWidget);
    expect(find.text('Correct 1'), findsOneWidget);
    expect(find.text('Wrong 1'), findsOneWidget);
    expect(find.text('Unanswered 1'), findsOneWidget);
    expect(find.text('Time 00:00'), findsOneWidget);

    // Per-question review.
    expect(find.text(_q1Prompt), findsOneWidget);
    expect(find.textContaining('Two has exactly two factors'), findsOneWidget);
    expect(find.text('A - Two'), findsOneWidget);
    expect(find.text('B - Twelve'), findsOneWidget);
    // The third review card sits below the fold: scroll it into view.
    await tester.scrollUntilVisible(
      find.textContaining('not answered'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('not answered'), findsOneWidget);

    // The attempt row and every answer row are persisted in drift.
    final repo = TestRepository(db);
    final student = state.currentStudent!;
    final attempts = await repo.attemptsForStudent(student.id);
    expect(attempts, hasLength(1));
    final attempt = attempts.single;
    expect(attempt.testId, test.id);
    expect(attempt.score, 0.75);
    expect(attempt.totalMarks, 3.0);
    expect(attempt.correctCount, 1);
    expect(attempt.wrongCount, 1);
    expect(attempt.unansweredCount, 1);

    final answers =
        await (db.select(db.testAttemptAnswers)
              ..where((t) => t.attemptId.equals(attempt.id))
              ..orderBy([(t) => OrderingTerm.asc(t.questionId)]))
            .get();
    expect(answers, hasLength(3));
    final byQuestion = {for (final a in answers) a.questionId: a};
    final questions = await repo.questionsForTest(test.id);
    expect(byQuestion[questions[0].id]!.selectedOption, 'A');
    expect(byQuestion[questions[0].id]!.isCorrect, isTrue);
    expect(byQuestion[questions[1].id]!.selectedOption, 'A');
    expect(byQuestion[questions[1].id]!.isCorrect, isFalse);
    expect(byQuestion[questions[2].id]!.selectedOption, isNull);
    expect(byQuestion[questions[2].id]!.isCorrect, isFalse);

    // Best score read path used by the Tests tab chip.
    expect(
      await repo.bestScoreForTest(testId: test.id, studentId: student.id),
      0.75,
    );
  });

  testWidgets('countdown reaches zero and auto-submits an empty attempt', (
    tester,
  ) async {
    final test = await createPublishedTest(
      title: 'Quick Check',
      timeLimitMinutes: 1,
      negativeMarking: 0,
    );
    await pumpRunner(tester, test);

    expect(find.text('Time left 01:00'), findsOneWidget);

    // Advance the fake clock past the 60 second limit; the runner must
    // submit on its own without the confirmation dialog.
    for (var i = 0; i < 62; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle();

    expect(find.text('Test result'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    expect(find.text('Unanswered 3'), findsOneWidget);

    final repo = TestRepository(db);
    final attempts = await repo.attemptsForStudent(state.currentStudent!.id);
    expect(attempts, hasLength(1));
    expect(attempts.single.score, 0.0);
    expect(attempts.single.totalMarks, 3.0);
    expect(attempts.single.unansweredCount, 3);
    expect(attempts.single.timeSpentSeconds, 60);

    final answers = await (db.select(
      db.testAttemptAnswers,
    )..where((t) => t.attemptId.equals(attempts.single.id))).get();
    expect(answers, hasLength(3));
    expect(answers.every((a) => a.selectedOption == null), isTrue);
  });
}
