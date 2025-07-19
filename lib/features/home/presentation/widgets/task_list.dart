import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/home/data/data_sources/dummy_data.dart';
import 'package:daily_activity/features/home/data/models/task_model.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_today_task.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<TaskModel> taskModel = dummyTasks;

    return SliverList.builder(
        itemCount: taskModel.length,
        itemBuilder: (context, index) {
          return CustomTodayTaskCard(taskModel: taskModel, index: index);
        });
  }
}
