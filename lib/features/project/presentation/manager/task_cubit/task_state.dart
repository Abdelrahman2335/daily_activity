part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSuccess extends TaskState {
  final List<TaskModel>? tasks;
  final Map<int, bool>?
      enabledFields; // Track enabled state for each task by index

  TaskSuccess({this.tasks, this.enabledFields});
}

final class TaskError extends TaskState {
  TaskError(this.errMessage);
  final String errMessage;
}
