import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../util.dart';
import 'sum_problem.dart';
import 'sum_problem_data.dart';

class AppModel extends ChangeNotifier {
  static const _lowValue = 0;
  static const _highValue = 9;

  // lowest possible sum answer
  static const _lowAnswer = _lowValue + _lowValue;

  // highest possible sum answer
  static const _highAnswer = _highValue + _highValue;
  static const _range = _highAnswer - _lowAnswer + 1;

  SumProblem _currentProblem;

  AppModel() {
    _newProblem();
  }

  SumProblem get currentProblem => _currentProblem;

  void Function() get onSkip {
    if (_currentProblem.solved) {
      return null;
    }

    return _newProblem;
  }

  void _newProblem() {
    if (_currentProblem != null) {
      _currentProblem.removeListener(_listener);
    }
    _currentProblem = _sampleProb();
    _currentProblem.addListener(_listener);
    notifyListeners();
  }

  void _listener() {
    if (_currentProblem.solved) {
      _newProblem();
    }
  }

  int _randomValue() =>
      _lowValue + sharedRandom.nextInt(_highValue - _lowValue + 1);

  SumProblem _sampleProb() {
    final a = _randomValue();
    final b = _randomValue();

    final data = SumProblemData(
      math.min(a, b),
      math.max(a, b),
    );

    return SumProblem(
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
