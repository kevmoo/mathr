import 'package:flutter/foundation.dart';

@immutable
abstract class ProblemData<T> {
  T get solution;

  String get problemText;
}
