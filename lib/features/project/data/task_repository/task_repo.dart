import 'package:daily_activity/core/models/task_model.dart';

abstract class TaskRepo {
  List<TaskModel> get currentTaskList;

  void addEmptyTask();
  void removeTask(int index);
}
