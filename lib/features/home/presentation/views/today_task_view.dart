import 'package:flowi/core/widgets/app_background.dart';
import 'package:flowi/features/home/presentation/widgets/today_task_view_body.dart';
import 'package:flutter/material.dart';

class TodayTasksView extends StatelessWidget {
  const TodayTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundLayout(children: [
        TodayTaskViewBody(),
      ]),
    );
  }
}
