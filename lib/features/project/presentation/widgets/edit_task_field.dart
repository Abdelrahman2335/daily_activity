import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/features/project/presentation/manager/edit_project_cubit/edit_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditTaskField extends StatelessWidget {
  const EditTaskField({
    super.key,
    this.index,
    this.initialValue,
  });

  final int? index;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        // Get the enabled state from the cubit instead of local state
        final isEnabled = index != null
            ? context.watch<TaskCubit>().isTaskFieldEnabled(index!)
            : true;

        return CustomTextFormField(
          key: ValueKey('edit_task_$index'),
          enableField: isEnabled,
          controller: initialValue != null
              ? TextEditingController(text: initialValue)
              : null,
          onSaved: (value) {
            context.read<EditProjectCubit>().tasksChange(TaskModel(
                  title: value ?? "",
                ));
          },
          onSecondPress: () {
            if (index != null) {
              context.read<TaskCubit>().toggleTaskFieldEnabled(index!);
            }
          },
          icon: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onLongPress: () {
                if (index != null) {
                  context.read<TaskCubit>().toggleTaskFieldEnabled(index!);
                }
              },
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.gripVertical)),
          maxLines: 1,
          hintText: 'Task Name',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => context.read<TaskCubit>().removeTask(index!),
          ),
        );
      },
    );
  }
}
