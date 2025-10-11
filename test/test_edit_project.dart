import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';

class TestEditProject {
  var category = categories.values;

  // Original project to be edited
  final originalProject = ProjectModel(
    title: "Original Title",
    description: "Original description",
    category: categories.values.elementAt(2),
    startDate: DateTime.now().subtract(Duration(days: 5)),
    endDate: DateTime.now().add(Duration(days: 10)),
    tasks: [
      TaskModel(title: "Original task 1", isCompleted: true),
      TaskModel(title: "Original task 2", isCompleted: false),
    ],
    status: TaskStatus.inProgress,
  );

  // Updated project data for testing edit functionality
  final updatedProject = ProjectModel(
    title: "Updated Title",
    description: "Updated description with more details",
    category: categories.values.elementAt(4),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 15)),
    tasks: [
      TaskModel(title: "Updated task 1", isCompleted: true),
      TaskModel(title: "Updated task 2", isCompleted: true),
      TaskModel(title: "New task 3", isCompleted: false),
    ],
    status: TaskStatus.inProgress,
  );
}
