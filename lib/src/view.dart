import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/problem_set.dart';
import 'problem_view.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<ProblemSet>(
        builder: (_, problemSet, __) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*
            Center(
              child: OutlineButton(
                  child: Text('Skip'), onPressed: problemSet.onSkip),
            ),*/
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200, maxHeight: 500),
              child: ChangeNotifierProvider.value(
                value: problemSet.currentProblem,
                child: ProblemView(),
              ),
            ),
            if (problemSet.stats != null)
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _data('Problems',
                      '${problemSet.visitedProblemCount}/${problemSet.problemCount}'),
                  _numData('Count', problemSet.stats.count),
                  _numData('Average', problemSet.stats.average),
                  _numData('Median', problemSet.stats.median),
                  _numData('Min', problemSet.stats.min),
                  _numData('Max', problemSet.stats.max),
                ],
              ),
          ],
        ),
      );
}

Widget _numData(String label, num data) =>
    _data(label, data.toStringAsFixed(1));

Widget _data(String label, String data) => Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        '$label: $data',
        textScaleFactor: 1.2,
      ),
    );
