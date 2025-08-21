import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/features/project/presentation/manager/add_project_cubit/add_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildTaskField extends StatelessWidget {
  const BuildTaskField({
    super.key,
    this.index,
  });
  final int? index;
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
       
      
        return CustomTextFormField(
          key: ValueKey(hashCode),
          onSaved: (value) {
            context.read<AddProjectCubit>().tasksChange(TaskModel(
                  title: value ?? "",
                ));
          },
        
          icon: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
           
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
