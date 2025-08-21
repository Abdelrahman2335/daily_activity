import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/edit_task_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTask extends StatefulWidget {
  const EditTask({
    super.key,
    required this.initialTasks,
  });

  final List<TaskModel> initialTasks;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().initializeForEditProject(widget.initialTasks);
  }

  @override
  Widget build(BuildContext context) {
    final taskList = context.watch<TaskCubit>().currentTaskList;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ...taskList.asMap().entries.map((entry) {
          int index = entry.key;
          TaskModel task = entry.value;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            key: ValueKey(task.id),
            child: EditTaskField(
              index: index,
              initialValue: task,
            ),
          );
        }),
        const SizedBox(height: 20),
        SecondaryButton(
          onPressed: () {
            context.read<TaskCubit>().addEmptyTask();
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
