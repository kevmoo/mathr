import 'problem.dart';
import 'problem_set.dart';
import 'sum_problem_data.dart';

class SumProblemSet extends ProblemSet<int, SumProblemData> {
  final int lowValue, highValue;

  SumProblemSet({
    this.lowValue = 0,
    this.highValue = 9,
  })  : assert(lowValue < highValue),
        super(_sumProblems(lowValue, highValue));

  @override
  Problem<int> problemFromData(SumProblemData data) => Problem(
        data,
        Iterable.generate(_range, (i) => i + _lowAnswer),
      );

  /// Lowest possible value for the range provided.
  int get _lowAnswer => lowValue + lowValue;

  /// Number of possible answers given [lowValue] and [highValue].
  int get _range => (highValue * 2) - _lowAnswer + 1;
}

Iterable<SumProblemData> _sumProblems(int lowValue, int highValue) sync* {
  assert(
    lowValue < highValue,
    '`highValue` must be strictly greater than `lowValue`.',
  );
  for (var i = lowValue; i <= highValue; i++) {
    for (var j = lowValue; j <= highValue; j++) {
      yield SumProblemData(i, j);
    }
  }
}
