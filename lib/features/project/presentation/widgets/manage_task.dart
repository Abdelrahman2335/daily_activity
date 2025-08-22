import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/task_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageTask extends StatelessWidget {
  const ManageTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<TaskModel> currentList =
        context.watch<ProjectCubit>().currentTasks;

    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is ProjectError) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text("Error"),
                content: Text(state.errMessage),
              );
            },
          );
          Future.delayed((Duration(seconds: 2)), () {
            GoRouter.maybeOf(context)?.pop();
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ...currentList.asMap().entries.map((entry) {
              int index = entry.key;
              TaskModel task = entry.value;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                key: ValueKey(task.id),
                child: TaskField(
                  index: index,
                  initialValue: task,
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
      },
    );
  }
}
