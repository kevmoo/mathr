import 'package:flutter/foundation.dart';

@immutable
class SumProblemData {
  final int first;
  final int second;

  SumProblemData(this.first, this.second);

  int get solution => first + second;
}
