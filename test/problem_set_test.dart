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

        final rightAnswer = previousProblem.answers.singleWhere(
            (element) => element.value == previousProblem.data.solution);
        rightAnswer.onClick();

        expect(
          probSet.visitedProblemCount,
          math.min(i + 1, probSet.problemCount),
          reason: 'if the right answer is clicked, the visited problem count '
              'should increase (until we hit the total problem count).',
        );
      }
    });
  });
}

SumProblemSet _simpleProblemSet() {
  final probSet = SumProblemSet(lowValue: 1, highValue: 3);

  expect(probSet.problemCount, 9);
  expect(probSet.visitedProblemCount, 0);
  return probSet;
}
