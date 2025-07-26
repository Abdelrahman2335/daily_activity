import 'package:daily_activity/features/add_task/presentation/widgets/build_task_field.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List taskList = [];

  @override
  void initState() {
    taskList = List.generate(6, (index) => BuildTaskField());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        // Working only if the Field is disabled (you will need to create the logic)
        setState(() {
          final task = taskList.removeAt(oldIndex);

          taskList.insert(newIndex, task);

          
        });
      },
      children: [
        ...taskList.map((element) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            key: ObjectKey(element),
            child: element,
          );
        })
      ],
    );
  }
}
