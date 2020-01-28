import 'problem.dart';
import 'problem_set.dart';
import 'sum_problem_data.dart';

Iterable<SumProblemData> _sumProblems(int lowValue, int highValue) sync* {
  if (lowValue >= highValue) {
    throw ArgumentError.value(
        highValue, 'highValue', 'must be strictly greater than `lowValue`.');
  }
  for (var i = lowValue; i <= highValue; i++) {
    for (var j = lowValue; j <= highValue; j++) {
      yield SumProblemData(i, j);
    }
  }
}

class SumProblemSet extends ProblemSet<int, SumProblemData> {
  final int lowValue, highValue;

  int get _lowAnswer => lowValue + lowValue;

  /// Number of possible answers between [_lowAnswer] and [_highAnswer],
  /// inclusive.
  int get _range => (highValue * 2) - _lowAnswer + 1;

  SumProblemSet({
    this.lowValue = 0,
    this.highValue = 9,
  }) : super(_sumProblems(lowValue, highValue));

  @override
  Problem<int> problemFromData(SumProblemData data) => Problem(
        data,
        Iterable.generate(_range, (i) => i + _lowAnswer),
      );
}
