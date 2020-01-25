import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/sum_problem_data.dart';

class ProblemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SumProblem>(
        builder: (_, problem, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                child: FittedBox(
                  // TODO: specific to a sum problem – should make generic
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
                        style: problem.solved
                            ? TextStyle(
                                color: Colors.green,
                              )
                            : null,
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
                spacing: 20,
                runSpacing: 20,
                children: <Widget>[
                  for (var answer in problem.answers)
                    FloatingActionButton(
                      disabledElevation: 0,
                      backgroundColor: answer.enabled
                          ? null
                          : Theme.of(context).disabledColor,
                      child: Text(
                        answer.value.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: answer.onClick,
                    )
                ],
              ),
            ),
          ],
        ),
      );
}
