import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/build_task_field.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List<TaskModel> taskList = [];
  void _removeTask(int index) {
    setState(() {
      if (taskList.length <= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("At least one task is required.")),
        );
        return;
      }
      taskList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final item = taskList.removeAt(oldIndex);
              if (newIndex > oldIndex) {
                newIndex -= 1; // Adjust for removal
              }
              taskList.insert(newIndex, item);
            });
          },
          children: [
            ...taskList.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                key: ValueKey(index),
                child: BuildTaskField(
                  onPressed: () => _removeTask(index),
                ),
              );
            })
          ],
        ),
        const SizedBox(height: 20),
        SecondaryButton(
          onPressed: () {
            setState(() {
              taskList.add(BuildTaskField(
                onPressed: () {
                  setState(() {
                    _removeTask(taskList.length);
                  });
                },
              ) as TaskModel);
            });
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
