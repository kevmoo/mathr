import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mathr/src/model/problem.dart';

import '../util.dart';
import 'problem_data.dart';

abstract class ProblemSet<T, PD extends ProblemData<T>> extends ChangeNotifier {
  final Map<PD, List> _problems = SplayTreeMap<PD, List>();

  ProblemSet(Iterable<PD> problems) {
    for (var problem in problems) {
      _problems[problem] = [];
    }

    _newProblem();
  }

  PD _nextProblemData() =>
      _problems.keys.elementAt(sharedRandom.nextInt(_problems.length));

  /// Overridden in subclass to create a new [Problem] given a [ProblemData].
  @protected
  Problem<T> nextProblem(PD data);

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
