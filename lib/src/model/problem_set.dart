import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:stats/stats.dart';

import '../util.dart';
import 'problem.dart';
import 'problem_data.dart';
import 'problem_score.dart';

abstract class ProblemSet<T, PD extends ProblemData<T>> extends ChangeNotifier {
  final _watch = Stopwatch()..start();
  final _problems = SplayTreeMap<PD, ProblemScore>();
  Problem<T> _currentProblem;
  Stats _statsCache;

  ProblemSet(Iterable<PD> problems) {
    assert(problems.length > 1, 'Must have at least 2 problems.');
    for (var problem in problems) {
      _problems[problem] = ProblemScore();
    }

    _newProblem();
  }

  Stats get stats =>
      _statsCache ??= _scoreEntries.isEmpty ? null : _scoreEntries.stats;

  int get problemCount => _problems.length;

  int get visitedProblemCount =>
      _problems.values.where((element) => element.hasEntries).length;

  /// Overridden in subclass to create a new [Problem] given a [ProblemData].
  @protected
  Problem<T> problemFromData(PD data);

  Problem<T> get currentProblem => _currentProblem;

  void Function() get onSkip {
    if (_currentProblem.solved) {
      return null;
    }

    return _newProblem;
  }

  Iterable<num> get _scoreEntries => _problems.values
      .map((element) => element.average)
      .where((element) => element != null);

  void _listener() {
    if (_currentProblem.solved) {
      _newProblem();
    }
  }

  void _newProblem() {
    if (_currentProblem != null) {
      _problems[_currentProblem.data].scoreCurrentProblem(
        _currentProblem,
        _watch.elapsed,
      );

      _statsCache = null;

      _currentProblem.removeListener(_listener);
    }
    final nextData = _nextProblemData();
    _currentProblem = problemFromData(nextData);
    assert(identical(nextData, _currentProblem.data));
    _currentProblem.addListener(_listener);
    assert(_watch.isRunning);
    _watch.reset();
    notifyListeners();
  }

  Iterable<MapEntry<PD, ProblemScore>> get _noRepeatEntries =>
      _problems.entries.where((element) {
        // Only consider problems that != the current problem (might be null)
        return element.key != _currentProblem?.data;
      });

  /// Many desired restrictions here.
  ///
  /// Next problem should:
  /// 1) not repeat the previous problem.
  /// 2) be in the set of questions that has been visited the least
  PD _nextProblemData() {
    //
    // First, prioritize problems with incorrect attemps
    //
    final withIncorrectAttempts = _noRepeatEntries
        .where((element) =>
            element.value.hasEntries &&
            element.value.totalIncorrectAttemptCount > 0)
        .toList(growable: false);

    if (withIncorrectAttempts.isNotEmpty) {
      return withIncorrectAttempts[
              sharedRandom.nextInt(withIncorrectAttempts.length)]
          .key;
    }

    //
    // Next, prioritize problems that have been asked least frequently
    //
    int lowestAnswerCount;
    final candidateProblems = <PD>[];

    for (var entry in _noRepeatEntries) {
      if (lowestAnswerCount == null ||
          lowestAnswerCount > entry.value.entryCount) {
        candidateProblems.clear();
        lowestAnswerCount = entry.value.entryCount;
      }

      if (entry.value.entryCount == lowestAnswerCount) {
        candidateProblems.add(entry.key);
      }
    }

    return candidateProblems[sharedRandom.nextInt(candidateProblems.length)];
  }
}
