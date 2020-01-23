import 'package:flutter/material.dart';
import 'package:mathr/src/model.dart';
import 'package:provider/provider.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SumProblem>(
        builder: (_, problem, __) => Column(
          children: <Widget>[
            Expanded(
              child: Placeholder(),
            ),
            Expanded(
              child: Placeholder(),
            ),
          ],
        ),
      );
}
