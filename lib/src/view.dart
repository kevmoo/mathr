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
              child: OutlineButton(
                child: Text('Skip'),
                onPressed: problemSet.onSkip,
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
