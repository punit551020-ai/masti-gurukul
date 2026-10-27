import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

// ---------------------------------------------------------------------------
// Pure grading logic. No Flutter imports in this section so it stays unit
// testable with plain `flutter test` / `dart test` and reusable by any
// future sync engine that wants to recompute scores server side.
// ---------------------------------------------------------------------------

/// The minimum a grader needs to know about one question.
class GradingQuestion {
  const GradingQuestion({
    required this.id,
    required this.correctOption,
    required this.marks,
  });

  final String id;
  final String correctOption;
  final double marks;
}

/// Per-question outcome produced by [grade].
class QuestionGrade {
  const QuestionGrade({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.marksAwarded,
  });

  final String questionId;
  final String? selectedOption;
  final bool isCorrect;
  final double marksAwarded;

  bool get answered => selectedOption != null;
}

/// Full result of scoring one attempt.
class GradeResult {
  const GradeResult({
    required this.score,
    required this.totalMarks,
    required this.correctCount,
    required this.wrongCount,
    required this.unansweredCount,
    required this.questionGrades,
  });

  final double score;
  final double totalMarks;
  final int correctCount;
  final int wrongCount;
  final int unansweredCount;
  final List<QuestionGrade> questionGrades;
}

/// Scores an answer map against a question list.
///
/// Rules:
/// * Correct option: the question's own `marks` are awarded (per-question
///   marks, not the test-level default).
/// * Wrong option: `negativeMarking` is subtracted, but a negative or zero
///   penalty never makes a wrong answer cost anything (it scores exactly 0,
///   it cannot add marks and the per-question award cannot go below 0
///   because of a bad penalty value).
/// * Unanswered / cleared: 0, counted separately.
/// * The total score may be negative when negative marking is enabled and
///   more marks are lost than gained; that is intentional for competitive
///   exams. Totals are rounded to two decimals to avoid float noise.
GradeResult grade({
  required List<GradingQuestion> questions,
  required Map<String, String?> selectedOptions,
  required double negativeMarking,
}) {
  final penalty = negativeMarking > 0 ? negativeMarking : 0.0;

  var score = 0.0;
  var totalMarks = 0.0;
  var correctCount = 0;
  var wrongCount = 0;
  var unansweredCount = 0;
  final grades = <QuestionGrade>[];

  for (final question in questions) {
    totalMarks += question.marks;
    final selection = selectedOptions[question.id];

    double awarded;
    bool isCorrect;
    if (selection == null) {
      awarded = 0;
      isCorrect = false;
      unansweredCount++;
    } else if (selection == question.correctOption) {
      awarded = question.marks;
      isCorrect = true;
      correctCount++;
    } else {
      awarded = -penalty;
      isCorrect = false;
      wrongCount++;
    }

    score += awarded;
    grades.add(
      QuestionGrade(
        questionId: question.id,
        selectedOption: selection,
        isCorrect: isCorrect,
        marksAwarded: awarded,
      ),
    );
  }

  return GradeResult(
    score: _round2(score),
    totalMarks: _round2(totalMarks),
    correctCount: correctCount,
    wrongCount: wrongCount,
    unansweredCount: unansweredCount,
    questionGrades: grades,
  );
}

double _round2(double value) => (value * 100).roundToDouble() / 100;

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

/// An attempt that has been started but not submitted yet. Nothing is written
/// to the database until [TestRepository.saveAttempt] runs, so abandoned tests
/// never pollute the progress statistics.
class StartedAttempt {
  const StartedAttempt({required this.id, required this.startedAt});

  final String id;
  final DateTime startedAt;
}

/// One row of the answer review on the result screen: the question plus what
/// the student chose.
class AttemptReviewItem {
  const AttemptReviewItem({
    required this.question,
    required this.selectedOption,
    required this.isCorrect,
  });

  final TestQuestion question;
  final String? selectedOption;
  final bool isCorrect;
}

/// A published test enriched with the chapter/subject it belongs to and the
/// live totals of its questions, so the Tests tab never has to guess.
class PublishedTestSummary {
  const PublishedTestSummary({
    required this.test,
    required this.chapter,
    required this.subject,
    required this.questionCount,
    required this.totalMarks,
  });

  final Test test;
  final Chapter chapter;
  final Subject subject;
  final int questionCount;
  final double totalMarks;
}

/// Read/write side of taking MCQ tests, on top of the local drift database.
///
/// The rows themselves are filled by the sync engine (Supabase -> drift);
/// this repository only reads content tables and writes the student's own
/// attempt rows.
class TestRepository {
  TestRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ------------------------------------------------------------ attempt flow

  /// Allocates an id for a new attempt. Nothing is persisted yet.
  StartedAttempt startAttempt() =>
      StartedAttempt(id: newAttemptId(), startedAt: DateTime.now());

  String newAttemptId() => 'attempt-${_uuid.v4()}';

  /// Grades [selectedOptions] against the questions currently stored for
  /// [testId] and writes the TestAttempts row plus every TestAttemptAnswers
  /// row in one transaction. Returns the persisted attempt.
  Future<TestAttempt> saveAttempt({
    required String testId,
    required String studentId,
    required Map<String, String?> selectedOptions,
    required int timeSpentSeconds,
    String? attemptId,
    DateTime? submittedAt,
  }) => _db.transaction(() async {
    final test = await (_db.select(
      _db.tests,
    )..where((t) => t.id.equals(testId))).getSingle();
    final questions =
        await (_db.select(_db.testQuestions)
              ..where((t) => t.testId.equals(testId))
              ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
            .get();

    final result = grade(
      questions: [
        for (final q in questions)
          GradingQuestion(
            id: q.id,
            correctOption: q.correctOption,
            marks: q.marks,
          ),
      ],
      selectedOptions: selectedOptions,
      negativeMarking: test.negativeMarking,
    );

    final id = attemptId ?? newAttemptId();
    final submitted = submittedAt ?? DateTime.now();

    final attempt = TestAttempt(
      id: id,
      testId: testId,
      studentId: studentId,
      score: result.score,
      totalMarks: result.totalMarks,
      correctCount: result.correctCount,
      wrongCount: result.wrongCount,
      unansweredCount: result.unansweredCount,
      timeSpentSeconds: timeSpentSeconds,
      submittedAt: submitted,
    );

    await _db.into(_db.testAttempts).insert(attempt.toCompanion(false));
    for (final gradeResult in result.questionGrades) {
      await _db
          .into(_db.testAttemptAnswers)
          .insert(
            TestAttemptAnswersCompanion.insert(
              attemptId: id,
              questionId: gradeResult.questionId,
              selectedOption: Value(gradeResult.selectedOption),
              isCorrect: Value(gradeResult.isCorrect),
            ),
          );
    }
    return attempt;
  });

  // ------------------------------------------------------------------- reads

  Future<List<TestAttempt>> attemptsForStudent(String studentId) =>
      (_db.select(_db.testAttempts)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm.desc(t.submittedAt)]))
          .get();

  Future<TestAttempt?> attemptById(String id) => (_db.select(
    _db.testAttempts,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Test?> testById(String id) =>
      (_db.select(_db.tests)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<TestQuestion>> questionsForTest(String testId) =>
      (_db.select(_db.testQuestions)
            ..where((t) => t.testId.equals(testId))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  /// Highest score this student ever reached on [testId], or null when the
  /// student has not attempted it.
  Future<double?> bestScoreForTest({
    required String testId,
    required String studentId,
  }) async {
    final best = _db.testAttempts.score.max();
    final row =
        await (_db.selectOnly(_db.testAttempts)
              ..addColumns([best])
              ..where(
                _db.testAttempts.testId.equals(testId) &
                    _db.testAttempts.studentId.equals(studentId),
              ))
            .getSingle();
    return row.read(best);
  }

  /// Most recent attempts of this student, newest first.
  Future<List<TestAttempt>> latestAttempts({
    required String studentId,
    int limit = 5,
  }) =>
      (_db.select(_db.testAttempts)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm.desc(t.submittedAt)])
            ..limit(limit))
          .get();

  /// Attempt plus every question in display order, for the result review.
  /// Returns null when the attempt does not exist.
  Future<({TestAttempt attempt, List<AttemptReviewItem> items})?>
  reviewForAttempt(String attemptId) async {
    final attempt = await attemptById(attemptId);
    if (attempt == null) return null;

    final answers = await (_db.select(
      _db.testAttemptAnswers,
    )..where((t) => t.attemptId.equals(attemptId))).get();
    final byQuestion = {for (final a in answers) a.questionId: a};

    final questions = await questionsForTest(attempt.testId);
    return (
      attempt: attempt,
      items: [
        for (final q in questions)
          AttemptReviewItem(
            question: q,
            selectedOption: byQuestion[q.id]?.selectedOption,
            isCorrect: byQuestion[q.id]?.isCorrect ?? false,
          ),
      ],
    );
  }

  // -------------------------------------------------------------- test list

  /// Published tests of [classId], each with chapter/subject context and the
  /// real question count and total marks read from the question rows.
  Future<List<PublishedTestSummary>> publishedTestSummariesForClass(
    String classId,
  ) async {
    final subjects =
        await (_db.select(_db.subjects)
              ..where((t) => t.classId.equals(classId))
              ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
            .get();
    if (subjects.isEmpty) return const [];

    final chapters =
        await (_db.select(_db.chapters)
              ..where(
                (t) => t.subjectId.isIn(subjects.map((s) => s.id).toList()),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.number)]))
            .get();
    if (chapters.isEmpty) return const [];

    final tests =
        await (_db.select(_db.tests)..where(
              (t) =>
                  t.chapterId.isIn(chapters.map((c) => c.id).toList()) &
                  t.isPublished.equals(true),
            ))
            .get();
    if (tests.isEmpty) return const [];

    final count = _db.testQuestions.id.count();
    final marks = _db.testQuestions.marks.sum();
    final statRows =
        await (_db.selectOnly(_db.testQuestions)
              ..addColumns([_db.testQuestions.testId, count, marks])
              ..where(
                _db.testQuestions.testId.isIn(tests.map((t) => t.id).toList()),
              )
              ..groupBy([_db.testQuestions.testId]))
            .get();
    final questionCount = <String, int>{};
    final totalMarks = <String, double>{};
    for (final row in statRows) {
      questionCount[row.read(_db.testQuestions.testId)!] =
          row.read(count)?.toInt() ?? 0;
      totalMarks[row.read(_db.testQuestions.testId)!] =
          row.read(marks)?.toDouble() ?? 0;
    }

    final chapterById = {for (final c in chapters) c.id: c};
    final subjectById = {for (final s in subjects) s.id: s};

    final summaries = <PublishedTestSummary>[];
    for (final test in tests) {
      final chapter = chapterById[test.chapterId];
      if (chapter == null) continue;
      final subject = subjectById[chapter.subjectId];
      if (subject == null) continue;
      summaries.add(
        PublishedTestSummary(
          test: test,
          chapter: chapter,
          subject: subject,
          questionCount: questionCount[test.id] ?? 0,
          totalMarks: totalMarks[test.id] ?? 0,
        ),
      );
    }

    summaries.sort((a, b) {
      final bySubject = a.subject.displayOrder.compareTo(
        b.subject.displayOrder,
      );
      if (bySubject != 0) return bySubject;
      final byChapter = a.chapter.number.compareTo(b.chapter.number);
      if (byChapter != 0) return byChapter;
      return a.test.title.compareTo(b.test.title);
    });
    return summaries;
  }
}
