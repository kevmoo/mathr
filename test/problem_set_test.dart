import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mathr/src/model/problem.dart';
import 'package:mathr/src/model/sum_problem_set.dart';

void main() {
  test('basic', () {
    final probSet = SumProblemSet();

    expect(probSet.problemCount, 100);
    expect(probSet.visitedProblemCount, 0);
  });

  group('next problem should', () {
    test('not repeat, prioritize infrequently answered problems', () {
      final probSet = _simpleProblemSet();

      Problem<int> previousProblem;
      for (var i = 0; i < 50; i++) {
        expect(
          probSet.currentProblem.data,
          isNot(previousProblem?.data),
          reason: 'Current problem should not be the same as the last problem',
        );
        previousProblem = probSet.currentProblem;
        previousProblem.correctAnswer.onClick();

        expect(
          probSet.visitedProblemCount,
          math.min(i + 1, probSet.problemCount),
          reason: 'if the right answer is clicked, the visited problem count '
              'should increase (until we hit the total problem count).',
        );
      }
    });

    test('prioritize questions with more wrong guesses', () {
      final probSet = _simpleProblemSet();

      final problem1 = probSet.currentProblem;

      // make 3 bad guesses
      for (var i = 0; i < 3; i++) {
        problem1.answers
            .firstWhere((element) =>
                element.enabled && element != problem1.correctAnswer)
            .onClick();

        expect(problem1.incorrectAttempts, i + 1);
      }

      problem1.correctAnswer.onClick();

      final problem2 = probSet.currentProblem;
      expect(problem2, isNot(problem1));

      problem2.correctAnswer.onClick();

      final problem3 = probSet.currentProblem;
      expect(problem3, problem1);
    });
  });
}

SumProblemSet _simpleProblemSet() {
  final probSet = SumProblemSet(lowValue: 1, highValue: 3);

  expect(probSet.problemCount, 9);
  expect(probSet.visitedProblemCount, 0);
  return probSet;
}
