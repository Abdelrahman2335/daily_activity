import 'package:daily_activity/features/add_task/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/features/home/presentation/widgets/today_task_app_bar.dart';
import 'package:flutter/material.dart';

class AddTaskViewBody extends StatelessWidget {
  const AddTaskViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TodayTasksAppBar(),
       const CustomDropDownButton(),
      ],
    );
  }
}

