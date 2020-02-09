import 'dart:math' as math;

class ScoreEntry {
  static const _maxPoints = 10;

  final bool solved;
  final int incorrectAttempts;
  final Duration elapsed;

  ScoreEntry(this.solved, this.incorrectAttempts, this.elapsed)
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

  @override
  String toString() => 'ScoreEntry solved:$solved; '
      'incorrectAttempts:$incorrectAttempts; elapsed:$elapsed';
}
