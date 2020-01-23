import 'package:flutter/foundation.dart';

class Model {
  SumProblem _currentProblem = SumProblem(SumProblemData(3, 4), []);

  SumProblem get currentProblem => _currentProblem;
}

Iterable<int> _answers(SumProblemData problem) sync* {
  yield problem.solution;
}

SumProblem sampleProb() {
  final data = SumProblemData(3, 4);
  return SumProblem(data, _answers(data));
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

  bool _enabled = false;

  Answer(this.value, this._parent);

  void Function() onClick() {
    if (_enabled) {
      return null;
    }

    return () => _parent._click(this);
  }
}
