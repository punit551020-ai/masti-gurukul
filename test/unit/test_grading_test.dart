import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/repositories/test_repository.dart';

GradeResult runGrade({
  required List<GradingQuestion> questions,
  required Map<String, String?> selections,
  double negativeMarking = 0,
}) => grade(
  questions: questions,
  selectedOptions: selections,
  negativeMarking: negativeMarking,
);

void main() {
  const threeOnes = [
    GradingQuestion(id: 'q1', correctOption: 'A', marks: 1),
    GradingQuestion(id: 'q2', correctOption: 'B', marks: 1),
    GradingQuestion(id: 'q3', correctOption: 'C', marks: 1),
  ];

  group('grade', () {
    test('all correct scores the full total', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'A', 'q2': 'B', 'q3': 'C'},
      );
      expect(result.score, 3.0);
      expect(result.totalMarks, 3.0);
      expect(result.correctCount, 3);
      expect(result.wrongCount, 0);
      expect(result.unansweredCount, 0);
      expect(result.questionGrades.map((g) => g.marksAwarded).toList(), [
        1.0,
        1.0,
        1.0,
      ]);
    });

    test('all wrong with negative marking subtracts per wrong answer', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'B', 'q2': 'C', 'q3': 'D'},
        negativeMarking: 0.25,
      );
      expect(result.score, -0.75);
      expect(result.totalMarks, 3.0);
      expect(result.correctCount, 0);
      expect(result.wrongCount, 3);
      expect(result.unansweredCount, 0);
      for (final g in result.questionGrades) {
        expect(g.isCorrect, isFalse);
        expect(g.answered, isTrue);
        expect(g.marksAwarded, -0.25);
      }
    });

    test('unanswered questions score zero and are counted', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'A', 'q2': null},
        negativeMarking: 0.5,
      );
      expect(result.correctCount, 1);
      expect(result.wrongCount, 0);
      expect(result.unansweredCount, 2);
      // 1 correct (+1), q2 explicitly cleared, q3 missing from the map.
      expect(result.score, 1.0);
    });

    test('per-question marks are used, not a flat default', () {
      const partialMarks = [
        GradingQuestion(id: 'q1', correctOption: 'A', marks: 2.5),
        GradingQuestion(id: 'q2', correctOption: 'B', marks: 0.5),
        GradingQuestion(id: 'q3', correctOption: 'C', marks: 1),
      ];
      final result = runGrade(
        questions: partialMarks,
        selections: const {'q1': 'A', 'q2': 'B', 'q3': 'A'},
        negativeMarking: 1,
      );
      expect(result.totalMarks, 4.0);
      // +2.5 + 0.5 - 1 penalty.
      expect(result.score, 2.0);
      expect(result.questionGrades[0].marksAwarded, 2.5);
      expect(result.questionGrades[1].marksAwarded, 0.5);
      expect(result.questionGrades[2].marksAwarded, -1.0);
    });

    test('wrong answers with zero negative marking score exactly 0', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'D', 'q2': 'A', 'q3': 'B'},
        negativeMarking: 0,
      );
      expect(result.score, 0.0);
      expect(result.score, isNot(lessThan(0.0)));
      expect(result.wrongCount, 3);
      for (final g in result.questionGrades) {
        expect(g.marksAwarded, 0.0);
      }
    });

    test('a bogus negative penalty never turns wrong answers into bonuses', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'B', 'q2': 'C', 'q3': 'D'},
        negativeMarking: -0.5,
      );
      expect(result.score, 0.0);
    });

    test('selections for unknown question ids are ignored', () {
      final result = runGrade(
        questions: threeOnes,
        selections: const {'q1': 'A', 'ghost': 'A'},
      );
      expect(result.score, 1.0);
      expect(result.questionGrades.length, 3);
    });

    test('empty question list grades to a zero attempt', () {
      final result = runGrade(questions: const [], selections: const {});
      expect(result.score, 0.0);
      expect(result.totalMarks, 0.0);
      expect(result.correctCount, 0);
      expect(result.wrongCount, 0);
      expect(result.unansweredCount, 0);
    });

    test('float noise is rounded to two decimals', () {
      const thirds = [
        GradingQuestion(id: 'q1', correctOption: 'A', marks: 0.1),
        GradingQuestion(id: 'q2', correctOption: 'A', marks: 0.1),
        GradingQuestion(id: 'q3', correctOption: 'A', marks: 0.1),
      ];
      final result = runGrade(
        questions: thirds,
        selections: const {'q1': 'A', 'q2': 'A', 'q3': 'A'},
      );
      expect(result.score, 0.3);
      expect(result.totalMarks, 0.3);
    });
  });
}
