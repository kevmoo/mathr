import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/app_model.dart';
import 'problem_view.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<AppModel>(
        builder: (_, appModel, __) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: OutlineButton(
                child: Text('Skip'),
                onPressed: appModel.onSkip,
              ),
            ),
            Expanded(
              flex: 3,
              child: ChangeNotifierProvider.value(
                value: appModel.currentProblem,
                child: ProblemView(),
              ),
            ),
          ],
        ),
      );
}
