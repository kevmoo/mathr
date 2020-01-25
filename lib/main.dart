import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/model/problem_set.dart';
import 'src/model/sum_problem_set.dart';
import 'src/view.dart';

void main() => runApp(MathrApp());

class MathrApp extends StatelessWidget {
  static const _title = 'mathr';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: _title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(_title),
          ),
          body: ChangeNotifierProvider<ProblemSet>(
            create: (_) => SumProblemSet(),
            child: AppView(),
          ),
        ),
      );
}
