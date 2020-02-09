import 'dart:collection';

import 'package:stats/stats.dart';

import 'problem.dart';
import 'score_entry.dart';

class ProblemScore {
  static const _maxEntries = 5;
  final _entries = ListQueue<ScoreEntry>();

  void scoreCurrentProblem(Problem problem, Duration elapsed) {
    _entries.add(
      ScoreEntry(problem.solved, problem.incorrectAttempts, elapsed),
    );

    while (_entries.length > _maxEntries) {
      _entries.removeLast();
    }
  }

  num get average => _entries.isEmpty
      ? null
      : _entries.map((element) => element.points).average;

  int get totalIncorrectAttemptCount =>
      _entries.map((element) => element.incorrectAttempts).sum;

  bool get hasEntries => _entries.isNotEmpty;

  int get entryCount => _entries.length;

  @override
  String toString() => 'ProblemScore: [${_entries.join(', ')}]';
}
