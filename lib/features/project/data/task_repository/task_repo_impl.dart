import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo.dart';

class TaskRepoImpl implements TaskRepo {
  List<TaskModel> taskList = [];

  @override
  List<TaskModel> get currentTaskList => List.unmodifiable(taskList);

  @override
  void addEmptyTask() {
    taskList.add(TaskModel(title: ""));
  }

  @override
  void removeTask(int index) {
    taskList.removeAt(index);
  }

}
