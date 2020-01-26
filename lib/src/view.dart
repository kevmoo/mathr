import 'package:flutter/material.dart';
import 'package:mathr/src/model/problem_set.dart';
import 'package:provider/provider.dart';

import 'problem_view.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<ProblemSet>(
        builder: (_, problemSet, __) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (problemSet.stats != null) ...[
                    _data('Count', problemSet.stats.count),
                    _data('Average', problemSet.stats.mean),
                    _data('Median', problemSet.stats.median),
                    _data('Min', problemSet.stats.min),
                    _data('Max', problemSet.stats.max)
                  ],
                  OutlineButton(
                    child: Text('Skip'),
                    onPressed: problemSet.onSkip,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ChangeNotifierProvider.value(
                value: problemSet.currentProblem,
                child: ProblemView(),
              ),
            ),
          ],
        ),
      );
}

Widget _data(String label, num data) => Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        '$label: ${data.toStringAsFixed(1)}',
        textScaleFactor: 1.2,
      ),
    );
