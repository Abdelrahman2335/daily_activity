import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo.dart';
import 'package:meta/meta.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.taskRepo) : super(TaskInitial());
  final TaskRepo taskRepo;

  // Track enabled state for each task field by index
  Map<int, bool> _enabledFields = {};

  List<TaskModel> get currentTaskList => taskRepo.currentTaskList;

  void addEmptyTask() {
    emit(TaskLoading());
    try {
      taskRepo.addEmptyTask();
      // Initialize new task as enabled
      _enabledFields[currentTaskList.length - 1] = true;
      emit(TaskSuccess(
        tasks: currentTaskList,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // Remove task at specific index
  void removeTask(int index) {
    try {
      if (currentTaskList.length <= 1) {
        emit(TaskError("At least one task is required"));
        return;
      }
      taskRepo.removeTask(index);

      // Remove the enabled state for this index and shift others
      Map<int, bool> newEnabledFields = {};
      _enabledFields.forEach((key, value) {
        if (key < index) {
          newEnabledFields[key] = value;
        } else if (key > index) {
          newEnabledFields[key - 1] = value;
        }
      });
      _enabledFields = newEnabledFields;

      emit(TaskSuccess(
        tasks: currentTaskList,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // Toggle enabled state for a specific task field
  void toggleTaskFieldEnabled(int index) {
    _enabledFields[index] = !(_enabledFields[index] ?? true);
    emit(TaskSuccess(
      tasks: currentTaskList,
    ));
  }

  // Get enabled state for a specific task field
  bool isTaskFieldEnabled(int index) {
    return _enabledFields[index] ?? true; // Default to enabled
  }

  // Set enabled state for a specific task field
  void setTaskFieldEnabled(int index, bool enabled) {
    _enabledFields[index] = enabled;
    emit(TaskSuccess(
      tasks: currentTaskList,
    ));
  }

  // Initialize with one empty task for new project
  void initializeForNewProject() {
    try {
      emit(TaskLoading());
      taskRepo.addEmptyTask();
      // Initialize first task as enabled
      _enabledFields[0] = true;
      emit(TaskSuccess(
        tasks: currentTaskList,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // Initialize with existing tasks for edit project
  void initializeForEditProject(List<TaskModel> existingTasks) {
    try {
      emit(TaskLoading());
      taskRepo.initializeWithTasks(existingTasks);
      for (int i = 0; i < existingTasks.length; i++) {
        _enabledFields[i] = true;
      }
      emit(TaskSuccess(
        tasks: currentTaskList,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
