import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/home/presentation/widgets/today_task_view_body.dart';
import 'package:flutter/material.dart';

class TodayTasksView extends StatelessWidget {
  const TodayTasksView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AppBackground(children: [
        TodayTaskViewBody(),
      ]),
    );
  }
}
