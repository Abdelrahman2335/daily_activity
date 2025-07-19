import 'package:daily_activity/features/home/presentation/widgets/custom_calender_list.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_status_bar.dart';
import 'package:daily_activity/features/home/presentation/widgets/today_task_app_bar.dart';
import 'package:flutter/material.dart';

class TodayTaskViewBody extends StatelessWidget {
  const TodayTaskViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TodayTasksAppBar(),
        const CustomCalenderList(),
        const SizedBox(height: 20),
        const CustomStatusBar(),
      ],
    );
  }
}
