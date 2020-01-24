import 'dart:math' as math;

import 'package:flutter/foundation.dart';

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

class SumProblem extends ChangeNotifier {
  final SumProblemData problem;

  final answers = <Answer>[];

  bool _solved = false;

  SumProblem(this.problem, Iterable<int> answerValues)
      : assert(
          answerValues.any((element) => element == problem.solution),
          'At least one answer should be the right solution.',
        ) {
    answers.addAll(answerValues.map((e) => Answer(e, this)));
  }

  bool get solved => _solved;

  void _click(Answer answer) {
    assert(answers.contains(answer));
    assert(answer._enabled);

    if (answer.value == problem.solution) {
      _solved = true;
      for (var value in answers) {
        value._enabled = false;
      }
    } else {
      answer._enabled = false;
    }
    notifyListeners();
  }
}

@immutable
class SumProblemData {
  final int first;
  final int second;

  SumProblemData(this.first, this.second);

  int get solution => first + second;
}

class Answer {
  final int value;
  final SumProblem _parent;

  bool _enabled = true;

  Answer(this.value, this._parent);

  bool get enabled => _enabled;

  void Function() get onClick {
    if (!_enabled) {
      return null;
    }

    return () => _parent._click(this);
  }
}
