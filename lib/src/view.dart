import 'package:flutter/material.dart';
import 'package:mathr/src/model.dart';
import 'package:provider/provider.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SumProblem>(
        builder: (_, problem, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                child: FittedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${problem.problem.first}\n+ ${problem.problem.second}',
                        textAlign: TextAlign.right,
                      ),
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: 25,
                      ),
                      Text(
                        problem.solved
                            ? problem.problem.solution.toString()
                            : '?',
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.center,
                spacing: 10,
                children: <Widget>[
                  for (var answer in problem.answers)
                    OutlineButton(
                      child: Text(answer.value.toString()),
                      onPressed: answer.onClick,
                    )
                ],
              ),
            ),
          ],
        ),
      );
}
