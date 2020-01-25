import '../util.dart';
import 'problem.dart';
import 'problem_set.dart';
import 'sum_problem_data.dart';

const _lowValue = 0;
const _highValue = 9;

/// lowest possible sum answer
const _lowAnswer = _lowValue + _lowValue;

/// highest possible sum answer
const _highAnswer = _highValue + _highValue;

/// Number of possible answers between [_lowAnswer] and [_highAnswer],
/// inclusive.
const _range = _highAnswer - _lowAnswer + 1;

Iterable<SumProblemData> _sumProblems() sync* {
  for (var i = _lowValue; i <= _highValue; i++) {
    for (var j = i; j <= _highValue; j++) {
      yield SumProblemData(i, j);
    }
  }
}

class SumProblemSet extends ProblemSet<int, SumProblemData> {
  SumProblemSet() : super(_sumProblems());

  @override
  Problem<int> nextProblem(SumProblemData data) {
    return Problem(
      _maybeFlip(data),
      Iterable.generate(_range, (i) => i + _lowAnswer),
    );
  }

  /// 50% chance that the returned value has [first] and [second] flipped.
  SumProblemData _maybeFlip(SumProblemData data) {
    if (sharedRandom.nextBool()) {
      return data;
    } else {
      return SumProblemData.raw(data.second, data.first);
    }
  }
}
