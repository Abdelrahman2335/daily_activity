import 'package:daily_activity/core/data/dummy_data.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_today_task.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/project_model.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<ProjectModel> taskModel = dummyTasks;

    return SliverList.builder(
        itemCount: taskModel.length,
        itemBuilder: (context, index) {
          return CustomTodayTaskCard(taskModel: taskModel, index: index);
        });
  }
}
