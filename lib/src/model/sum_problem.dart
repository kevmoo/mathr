import 'package:flutter/foundation.dart';

@immutable
class SumProblemData {
  final int first;
  final int second;

  /// Requires that [first] <= [second]. Used to normalize values for tracking
  /// progress.
  SumProblemData(this.first, this.second) : assert(first <= second);

  SumProblemData.raw(this.first, this.second);

  int get solution => first + second;
}
