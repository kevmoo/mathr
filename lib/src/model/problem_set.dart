import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mathr/src/model/problem.dart';

import '../util.dart';
import 'problem_data.dart';

abstract class ProblemSet<T> extends ChangeNotifier {
  final Map<ProblemData<T>, List> _problems =
      SplayTreeMap<ProblemData<T>, List>();

  ProblemSet(Iterable<ProblemData<T>> problems) {
    for (var problem in problems) {
      _problems[problem] = [];
    }

    _newProblem();
  }

  ProblemData<T> _nextProblemData() =>
      _problems.keys.elementAt(sharedRandom.nextInt(_problems.length));

  @protected
  Problem<T> nextProblem(ProblemData<T> data);

  Problem<T> _currentProblem;

  Problem<T> get currentProblem => _currentProblem;

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
    _currentProblem = nextProblem(_nextProblemData());
    _currentProblem.addListener(_listener);
    notifyListeners();
  }

  void _listener() {
    if (_currentProblem.solved) {
      _newProblem();
    }
  }
}
