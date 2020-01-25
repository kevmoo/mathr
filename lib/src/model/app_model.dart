import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'sum_problem.dart';
import 'sum_problem_data.dart';

class AppModel extends ChangeNotifier {
  static const _lowValue = 0;
  static const _highValue = 9;

  // lowest possible answer
  static const _lowAnswer = _lowValue + _lowValue;

  // higest possible answer
  static const _highAnswer = _highValue + _highValue;
  static const _range = _highAnswer - _lowAnswer + 1;

  final _rnd = math.Random();

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

  int get _randomValue => _lowValue + _rnd.nextInt(_highValue - _lowValue + 1);

  SumProblem _sampleProb() {
    final data = SumProblemData(
      _randomValue,
      _randomValue,
    );

    return SumProblem(data, Iterable.generate(_range, (i) => i + _lowAnswer));
  }
}
