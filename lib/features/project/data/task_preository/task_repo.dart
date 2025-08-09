import 'package:daily_activity/core/models/task_model.dart';

abstract class TaskRepo {
  List<TaskModel> get currentTaskList;
  TaskModel createEmptyTask();
  void addTaskToList();
  void removeTask(int index);
  void reorderTaskList(int oldIndex, int newIndex);
}
