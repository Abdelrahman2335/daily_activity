import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo.dart';

class TaskRepoImpl implements TaskRepo {
  List<TaskModel> taskList = [];

  @override
  List<TaskModel> get currentTaskList => List.unmodifiable(taskList);

  @override
  void addTaskToList(TaskModel newTask) {
    taskList.add(newTask);
  }

  @override
  void removeTask(int index) {
    taskList.removeAt(index);
  }

  @override
  void reorderTaskList(int oldIndex, int newIndex) {
    if (oldIndex >= 0 &&
        oldIndex < taskList.length &&
        newIndex >= 0 &&
        newIndex < taskList.length) {
      final item = taskList.removeAt(oldIndex);
      if (newIndex > oldIndex) newIndex -= 1;
      taskList.insert(newIndex, item);
    }
  }

  @override
  void addEmptyTask() {
    taskList.add(TaskModel(title: ""));
  }
}
