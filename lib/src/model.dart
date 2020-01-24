import 'package:flutter/foundation.dart';

SumProblem sampleProb() {
  final data = SumProblemData(3, 4);
  return SumProblem(data, Iterable.generate(20));
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

  void Function() get onClick {
    if (!_enabled) {
      return null;
    }

    return () => _parent._click(this);
  }
}
