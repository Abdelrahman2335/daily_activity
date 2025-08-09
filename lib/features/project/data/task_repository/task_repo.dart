import 'package:daily_activity/core/models/task_model.dart';

abstract class TaskRepo {
  TaskModel createEmptyTask();
  List<TaskModel> getAllTasks({required String projectId});
  List<TaskModel> addTaskToList(List<TaskModel> currentList, TaskModel newTask);
  void updateTask(TaskModel updatedTask);

  List<TaskModel> reorderTaskList(
      List<TaskModel> tasks, int oldIndex, int newIndex);

  bool canRemoveTask(List<TaskModel> taskList);
  bool isValidTask(TaskModel task);
}
