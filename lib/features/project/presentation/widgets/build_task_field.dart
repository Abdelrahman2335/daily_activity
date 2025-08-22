import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildTaskField extends StatelessWidget {
  const BuildTaskField({
    super.key,
    this.index,
  });
  final int? index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is ProjectError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomTextFormField(
          key: ValueKey(hashCode),
          onSaved: (value) {
            context.read<ProjectCubit>().tasksChange(TaskModel(
                  title: value ?? "",
                ));
          },
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
