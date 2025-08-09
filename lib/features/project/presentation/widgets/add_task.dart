import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/build_task_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().initializeForNewProject();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = context.watch<TaskCubit>().currentTaskList;

    return Column(
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            context.read<TaskCubit>().reorderTasks(oldIndex, newIndex);
          },
          children: [
            ...taskList.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                key: ValueKey(index),
                child: BuildTaskField(
                  index: index,
                ),
              );
            })
          ],
        ),
        const SizedBox(height: 20),
        SecondaryButton(
          onPressed: () {
            context.read<TaskCubit>().addEmptyTask();
          },
          buttonLabel: Text("Add Task",
              style: AppTextStyles.textStyle14.copyWith(
                color: AppColor.accentOrange,
              )),
          backgroundColor: AppColor.card,
          textColor: AppColor.accentOrange,
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
        ),
      ],
    );
  }
}
