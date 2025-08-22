import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskField extends StatelessWidget {
  const TaskField({
    super.key,
    this.index,
    required this.initialValue,
  });

  final int? index;
  final TaskModel initialValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        TaskModel? currentTask = initialValue;

        if (state is ProjectFormState) {
          final taskIndex = state.project.tasks
              .indexWhere((task) => task.id == initialValue.id);
          if (taskIndex != -1) {
            currentTask = state.project.tasks[taskIndex];
          }
        }

        return CustomTextFormField(
          initialValue: currentTask.title,
          key: ValueKey(index),
          onSaved: (value) {
            context.read<ProjectCubit>().tasksChange(TaskModel(
                  id: currentTask!.id,
                  title: value ?? "",
                  isCompleted: currentTask.isCompleted,
                ));
          },
          icon: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              color: currentTask.isCompleted == true
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              onPressed: () {
                final task = TaskModel(
                    title: currentTask!.title,
                    id: currentTask.id,
                    isCompleted: !currentTask.isCompleted!);
                context.read<ProjectCubit>().toggleTask(task);
                DebugLogger.log("Task marked as ${task.isCompleted}");
              },
              icon: Icon(FontAwesomeIcons.circleCheck)),
          maxLines: 1,
          hintText: 'Task Name',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => context.read<ProjectCubit>().removeTask(index!),
          ),
        );
      },
    );
  }
}
