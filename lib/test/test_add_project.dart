import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';

class TestAddProject {
  final testProject = ProjectModel(
    title: "title",
    description: "description",
    category: categories.values.elementAt(6),
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    tasks: [
      TaskModel(title: "title task", isCompleted: false),
      TaskModel(title: "title task 3", isCompleted: true),
      TaskModel(title: "title task 3", isCompleted: true),
      TaskModel(title: "title task 4 ", isCompleted: true),
    ],
    status: TaskStatus.completed,
  );
}
