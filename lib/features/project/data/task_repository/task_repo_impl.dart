import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo.dart';

class TaskRepoImpl implements TaskRepo {
  @override
  List<TaskModel> addTaskToList(
      List<TaskModel> currentList, TaskModel newTask) {
    // TODO: implement addTaskToList
    throw UnimplementedError();
  }

  @override
  bool canRemoveTask(List<TaskModel> taskList) {
    // TODO: implement canRemoveTask
    throw UnimplementedError();
  }

  @override
  TaskModel createEmptyTask() {
    // TODO: implement createEmptyTask
    throw UnimplementedError();
  }

  @override
  List<TaskModel> getAllTasks({required String projectId}) {
    // TODO: implement getAllTasks
    throw UnimplementedError();
  }

  @override
  bool isValidTask(TaskModel task) {
    // TODO: implement isValidTask
    throw UnimplementedError();
  }

  @override
  List<TaskModel> reorderTaskList(
      List<TaskModel> tasks, int oldIndex, int newIndex) {
    // TODO: implement reorderTaskList
    throw UnimplementedError();
  }

  @override
  void updateTask(TaskModel updatedTask) {
    // TODO: implement updateTask
  }
}
