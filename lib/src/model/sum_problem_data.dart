import 'package:flutter/foundation.dart';

import 'sum_problem.dart';

class SumProblem extends ChangeNotifier {
  final SumProblemData problem;

  final answers = <SumProblemAnswer>[];

  bool _solved = false;

  SumProblem(this.problem, Iterable<int> answerValues)
      : assert(
          answerValues.any((element) => element == problem.solution),
          'At least one answer should be the right solution.',
        ) {
    answers.addAll(answerValues.map((e) => SumProblemAnswer(e, this)));
  }

  bool get solved => _solved;

  void _click(SumProblemAnswer answer) {
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

class SumProblemAnswer {
  final int value;
  final SumProblem _parent;

  bool _enabled = true;

  SumProblemAnswer(this.value, this._parent);

  bool get enabled => _enabled;

  void Function() get onClick {
    if (!_enabled) {
      return null;
    }

    return () => _parent._click(this);
  }
}
