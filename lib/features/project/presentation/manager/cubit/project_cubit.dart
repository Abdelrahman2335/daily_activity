import 'package:bloc/bloc.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/debug_logger.dart';
import 'package:flowi/features/project/data/project_repository/project_repo.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_validators.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this.projectRepo, {this.initialProject})
      : super(_initialState(initialProject));

  final ProjectRepository projectRepo;
  final ProjectModel? initialProject;

  static ProjectFormState _initialState(ProjectModel? project) {
    final initial = project ?? emptyDraft();
    return ProjectFormState(
      project: initial,
      isValid: ProjectValidators.isFormValid(initial),
    );
  }

  /// Blank project used when creating a new one.
  static ProjectModel emptyDraft() => ProjectModel(
        title: "",
        description: "",
        category: categories[ProjectCategory.dailyStudy]!,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        tasks: [TaskModel(title: "")],
        status: TaskStatus.notStarted,
      );

  List<TaskModel> get currentTasks => _currentFormState.project.tasks;

  ProjectFormState get _currentFormState {
    final currentState = state;
    if (currentState is ProjectFormState) {
      return currentState;
    }
    return ProjectFormState(project: emptyDraft(), isValid: false);
  }

  /// Emits a form state whose validity is derived from [project], so the
  /// cubit's notion of "valid" always matches the UI validators.
  void _emitForm(ProjectModel project, {String? logMessage}) {
    emit(ProjectFormState(
      project: project,
      isValid: ProjectValidators.isFormValid(project),
    ));
    if (logMessage != null) {
      DebugLogger.log("emit new state with $logMessage", tag: "ProjectCubit");
    }
  }

  void _emitUpdated(
      ProjectModel Function(ProjectModel current) update,
      String logMessage) {
    _emitForm(
      update(_currentFormState.project),
      logMessage: logMessage,
    );
  }

  void titleChange(String title) {
    DebugLogger.log("titleChange called with Title: $title",
        tag: "ProjectCubit");

    _emitUpdated((project) => project.copyWith(title: title), "title: $title");
  }

  void descriptionChange(String description) {
    DebugLogger.log("descriptionChange called with description: $description",
        tag: "ProjectCubit");

    _emitUpdated(
      (project) => project.copyWith(description: description),
      "description: $description",
    );
  }

  void categoryChange(ProjectCategoryModel category) {
    DebugLogger.log("categoryChange called with category: $category",
        tag: "ProjectCubit");

    _emitUpdated(
      (project) => project.copyWith(category: category),
      "category: ${category.title}",
    );
  }

  void startDateChange(DateTime startDate) {
    DebugLogger.log("startDateChange called with startDate: $startDate",
        tag: "ProjectCubit");

    _emitUpdated(
      (project) => project.copyWith(startDate: startDate),
      "startDate: $startDate",
    );
  }

  void endDateChange(DateTime endDate) {
    DebugLogger.log("endDateChange called with endDate: $endDate",
        tag: "ProjectCubit");

    _emitUpdated(
      (project) => project.copyWith(endDate: endDate),
      "endDate: $endDate",
    );
  }

  void tasksChange(TaskModel task) {
    DebugLogger.log("tasksChange called with tasks: $task",
        tag: "ProjectCubit");

    List<TaskModel> updatedTasks = List.from(_currentFormState.project.tasks);

    int existingIndex = updatedTasks.indexWhere((i) => i.id == task.id);
    if (existingIndex != -1) {
      updatedTasks[existingIndex] = task;
    } else {
      updatedTasks.add(task);
    }

    _emitForm(
      _currentFormState.project.copyWith(tasks: updatedTasks),
      logMessage: "tasks: $updatedTasks",
    );
    _syncStatusWithTasks(updatedTasks);
  }

  void removeTask(int index) {
    DebugLogger.log("removeTask called with index: $index",
        tag: "ProjectCubit");
    List<TaskModel> currentTasks = List.from(_currentFormState.project.tasks);
    DebugLogger.log("currentTasks called with length: ${currentTasks.length}",
        tag: "ProjectCubit");

    // Validate index bounds
    if (index < 0 || index >= currentTasks.length) {
      emit(ProjectError("Invalid task index"));
      return;
    }
    if (currentTasks.length <= 1) {
      emit(ProjectError("At least one task is required"));
      return;
    }
    DebugLogger.log("We are removing the index $index after check");

    currentTasks.removeAt(index);
    _emitForm(_currentFormState.project.copyWith(tasks: currentTasks));
    _syncStatusWithTasks(currentTasks);

    DebugLogger.log(
        "Task removed successfully. Remaining tasks: ${currentTasks.length}",
        tag: "ProjectCubit");
  }

  void toggleTask(TaskModel task) {
    DebugLogger.log(
        "toggleTask called with task: ${task.title}, isCompleted: ${task.isCompleted}",
        tag: "ProjectCubit");

    List<TaskModel> updatedTasks = List.from(_currentFormState.project.tasks);
    int taskIndex = updatedTasks.indexWhere((i) => i.id == task.id);

    if (taskIndex == -1) {
      DebugLogger.logError("Task with id ${task.id} not found",
          context: "ProjectCubit");
      return;
    }

    updatedTasks[taskIndex] = task;

    _emitForm(_currentFormState.project.copyWith(tasks: updatedTasks));
    _syncStatusWithTasks(updatedTasks);

    DebugLogger.log(
        "Task toggled successfully: ${updatedTasks[taskIndex].isCompleted}",
        tag: "ProjectCubit");
  }

  void statusChange(TaskStatus status) {
    DebugLogger.log("statusChange called with status: $status",
        tag: "ProjectCubit");

    _emitUpdated(
      (project) => project.copyWith(status: status),
      "status: $status",
    );
  }

  /// Derives the project status from its tasks.
  void _syncStatusWithTasks(List<TaskModel> tasks) {
    bool isCompleted = tasks.every((i) => i.isCompleted == true);
    bool inProgress = tasks.any((i) => i.isCompleted == true);

    if (isCompleted) {
      statusChange(TaskStatus.completed);
    } else if (inProgress) {
      statusChange(TaskStatus.inProgress);
    } else {
      statusChange(TaskStatus.notStarted);
    }
  }

  /// Saves the current form.
  ///
  /// Returns `true` when the project was persisted, `false` when the form is
  /// invalid (nothing is emitted in that case) or when the repository failed
  /// (a [ProjectError] is emitted). Callers should only navigate away on
  /// `true`.
  Future<bool> submitForm() async {
    DebugLogger.log('submitForm called', tag: 'ProjectCubit');

    final formState = _currentFormState;

    if (!formState.isValid) {
      DebugLogger.logError("Form is not valid, cannot submit",
          context: "ProjectCubit");
      return false;
    }

    final project = formState.project;

    return initialProject == null
        ? addProject(project: project)
        : editProject(project: project);
  }

  Future<bool> editProject({required ProjectModel project}) async {
    var result = await projectRepo.editProject(updatedProject: project);

    return result.fold((errMessage) {
      emit(ProjectError(errMessage));
      return false;
    }, (_) {
      emit(ProjectSuccess());
      return true;
    });
  }

  Future<bool> addProject({required ProjectModel project}) async {
    var result = await projectRepo.addProject(project: project);

    return result.fold((errMessage) {
      emit(ProjectError(errMessage));
      return false;
    }, (_) {
      emit(ProjectSuccess());
      return true;
    });
  }

  Future<bool> deleteProject({required String projectId}) async {
    var result = await projectRepo.deleteProject(projectId: projectId);

    return result.fold((errMessage) {
      emit(ProjectError(errMessage));
      return false;
    }, (_) {
      emit(ProjectSuccess());
      return true;
    });
  }
}
