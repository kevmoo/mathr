import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mathr/src/model/problem.dart';
import 'package:stats/stats.dart';

import '../util.dart';
import 'problem_data.dart';

class _ProblemScore {
  static const _maxEntries = 5;
  final _entries = ListQueue<_ScoreEntry>();

  void _scoreCurrentProblem(Problem problem, Duration elapsed) {
    _entries.add(_ScoreEntry(problem.solved, problem.wrongAnswers, elapsed));

    while (_entries.length > _maxEntries) {
      _entries.removeLast();
    }
  }

  num get average => _entries.isEmpty
      ? null
      : _entries.map((element) => element.points).average;
}

class _ScoreEntry {
  static const _maxPoints = 10;

  final bool solved;
  final int incorrectAttempts;
  final Duration elapsed;

  _ScoreEntry(this.solved, this.incorrectAttempts, this.elapsed)
      : assert(incorrectAttempts >= 0),
        assert(!elapsed.isNegative);

  bool get skipped => !solved;

  int get points {
    if (!solved) {
      return _maxPoints;
    }

    // no more than 10 – or other value DBD
    return math.min(incorrectAttempts * 2 + elapsed.inSeconds, _maxPoints);
  }
}

abstract class ProblemSet<T, PD extends ProblemData<T>> extends ChangeNotifier {
  final _watch = Stopwatch()..start();
  final _problems = SplayTreeMap<PD, _ProblemScore>();
  Problem<T> _currentProblem;
  Stats _statsCache;

  ProblemSet(Iterable<PD> problems) {
    for (var problem in problems) {
      _problems[problem] = _ProblemScore();
    }

    _newProblem();
  }

  Stats get stats => _statsCache ??=
      _scoreEntries.isEmpty ? null : Stats.fromData(_scoreEntries);

  int get problemCount => _problems.length;

  int get visitedProblemCount =>
      _problems.values.where((element) => element._entries.isNotEmpty).length;

  /// Overridden in subclass to create a new [Problem] given a [ProblemData].
  @protected
  Problem<T> nextProblem(PD data);

  PD _nextProblemData() =>
      _problems.keys.elementAt(sharedRandom.nextInt(_problems.length));

  Problem<T> get currentProblem => _currentProblem;

  Iterable<num> get _scoreEntries => _problems.values
      .map((element) => element.average)
      .where((element) => element != null);

  void Function() get onSkip {
    if (_currentProblem.solved) {
      return null;
    }

    return _newProblem;
  }

  void _newProblem() {
    if (_currentProblem != null) {
      _problems[_currentProblem.data]._scoreCurrentProblem(
        _currentProblem,
        _watch.elapsed,
      );

      _statsCache = null;

      _currentProblem.removeListener(_listener);
    }
    final nextData = _nextProblemData();
    _currentProblem = nextProblem(nextData);
    assert(identical(nextData, _currentProblem.data));
    _currentProblem.addListener(_listener);
    assert(_watch.isRunning);
    _watch.reset();
    notifyListeners();
  }

  void _listener() {
    if (_currentProblem.solved) {
      _newProblem();
    }
  }
}
