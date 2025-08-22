import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/build_task_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTask extends StatelessWidget {
  const AddTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final taskList = context.watch<ProjectCubit>().currentTasks;
    return Column(
      children: [
        ...taskList.asMap().entries.map((entry) {
          int index = entry.key;
          TaskModel task = entry.value;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            key: ValueKey(task.id),
            child: BuildTaskField(
              index: index,
            ),
          );
        }),
        const SizedBox(height: 20),
        SecondaryButton(
          onPressed: () {
            context.read<ProjectCubit>().tasksChange(TaskModel(title: ""));
          },
          buttonLabel: Text("Add Task",
              style: AppTextStyles.textStyle14.copyWith(
                color: AppColor.accentOrange,
              )),
          backgroundColor: colorScheme.surface,
          textColor: AppColor.accentOrange,
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
        ),
      ],
    );
  }
}
