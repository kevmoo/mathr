import 'package:flutter/foundation.dart';

import 'problem_data.dart';

@immutable
class SumProblemData extends ProblemData<int>
    implements Comparable<SumProblemData> {
  final int first;
  final int second;

  /// Requires that [first] <= [second]. Used to normalize values for tracking
  /// progress.
  SumProblemData(this.first, this.second) : assert(first <= second);

  SumProblemData.raw(this.first, this.second);

  int get solution => first + second;

  @override
  int compareTo(SumProblemData other) {
    var value = first.compareTo(other.first);

    if (value == 0) {
      value = second.compareTo(other.second);
    }
    return value;
  }

  @override
  int get hashCode => first * 17 ^ second;

  @override
  bool operator ==(Object other) =>
      other is SumProblemData && first == other.first && second == other.second;

  @override
  String get problemText => '$first\n+ $second';
}
