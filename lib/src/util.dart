import 'dart:math' as math;

final sharedRandom = math.Random();

extension StatsExtensions on Iterable<num> {
  /// Returns the sum of all values in `this`.
  num get sum {
    num runningSum = 0;
    for (var value in this) {
      runningSum += value;
    }

    return runningSum;
  }

  /// Returns the average (mean) of all values in `this`.
  ///
  /// `this` is only enumerated once.
  num get average {
    var count = 0;
    num runningSum = 0;
    for (var value in this) {
      count++;
      runningSum += value;
    }

    return runningSum / count;
  }
}
