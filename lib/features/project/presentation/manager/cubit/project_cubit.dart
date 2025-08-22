import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo.dart';
import 'package:flutter/widgets.dart';

import 'package:meta/meta.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this.projectRepo, {this.initialProject})
      : super(
          ProjectFormState(
              project: initialProject ??
                  ProjectModel(
                    title: "",
                    description: "",
                    category: categories[ProjectCategory.dailyStudy]!,
                    startDate: DateTime.now(),
                    endDate: DateTime.now(),
                    tasks: [TaskModel(title: "")],
                    status: TaskStatus.notStarted,
                  ),
              isValid: true),
        );
  final ProjectRepository projectRepo;
  final ProjectModel? initialProject;
  List<TaskModel> get currentTasks => _currentFormState.project.tasks;
  ProjectFormState get _currentFormState {
    final currentState = state;
    if (currentState is ProjectFormState) {
      return currentState;
    }
    return ProjectFormState(
        project: ProjectModel(
          title: "",
          description: "",
          category: categories[ProjectCategory.dailyStudy]!,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          tasks: [TaskModel(title: "")],
          status: TaskStatus.notStarted,
        ),
        isValid: false);
  }

  bool _validForm(ProjectFormState state) {
    bool isValid = state.description.isNotEmpty &&
        state.title.isNotEmpty &&
        state.tasks.isNotEmpty;
    DebugLogger.log("validForm is: $isValid");

    return isValid;
  }

  void titleChange(String title) {
    DebugLogger.log("titleChange called with Title: $title",
        tag: "ProjectCubit");

    final updateProject = _currentFormState.project.copyWith(title: title);
    final formState = ProjectFormState(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );
    emit(formState);
    DebugLogger.log("emit new state with title: ${formState.title}",
        tag: "ProjectCubit");
  }

  void descriptionChange(String description) {
    DebugLogger.log("descriptionChange called with description: $description",
        tag: "ProjectCubit");

    final updateProject =
        _currentFormState.project.copyWith(description: description);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(ProjectFormState(project: updateProject)),
    );
    emit(formState);
    DebugLogger.log("emit new state with description: ${formState.description}",
        tag: "ProjectCubit");
  }

  void categoryChange(ProjectCategoryModel category) {
    DebugLogger.log("categoryChange called with category: $category",
        tag: "ProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(category: category);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with category: ${formState.category.title}",
        tag: "ProjectCubit");
  }

  void startDateChange(DateTime startDate) {
    DebugLogger.log("startDateChange called with startDate: $startDate",
        tag: "ProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(startDate: startDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with startDate: ${formState.startDate}",
        tag: "ProjectCubit");
  }

  void endDateChange(DateTime endDate) {
    DebugLogger.log("endDateChange called with endDate: $endDate",
        tag: "ProjectCubit");
    final updateProject = _currentFormState.project.copyWith(endDate: endDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with endDate: ${formState.endDate}",
        tag: "ProjectCubit");
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

    final updateProject =
        _currentFormState.project.copyWith(tasks: updatedTasks);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );

    emit(formState);

    bool isCompleted = updatedTasks.every((i) => i.isCompleted == true);
    bool inProgress = updatedTasks.any((i) => i.isCompleted == true);

    if (isCompleted) {
      statusChange(TaskStatus.completed);
    } else if (inProgress) {
      statusChange(TaskStatus.inProgress);
    } else {
      statusChange(TaskStatus.notStarted);
    }
    DebugLogger.log("emit new state with tasks: ${formState.tasks}",
        tag: "ProjectCubit");
  }

  void removeTask(int index) {
    DebugLogger.log("removeTask called with index: $index",
        tag: "ProjectCubit");
    List<TaskModel> currentTasks = List.from(_currentFormState.project.tasks);
    DebugLogger.log("currentTasks called with length: ${currentTasks.length}",
        tag: "ProjectCubit");
    if (currentTasks.length <= 1) {
      emit(ProjectError("At least one task is required"));
    } else {
      currentTasks.removeAt(index);
      final updateProject =
          _currentFormState.project.copyWith(tasks: currentTasks);
      final formState = _currentFormState.copyWith(
          project: updateProject,
          isValid: _validForm(ProjectFormState(project: updateProject)));
      emit(formState);
    }
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

    final updateProject =
        _currentFormState.project.copyWith(tasks: updatedTasks);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(ProjectFormState(project: updateProject)),
    );

    emit(formState);

    // Update project status based on task completion
    bool isCompleted = updatedTasks.every((i) => i.isCompleted == true);
    bool inProgress = updatedTasks.any((i) => i.isCompleted == true);

    if (isCompleted) {
      statusChange(TaskStatus.completed);
    } else if (inProgress) {
      statusChange(TaskStatus.inProgress);
    } else {
      statusChange(TaskStatus.notStarted);
    }

    DebugLogger.log(
        "Task toggled successfully: ${updatedTasks[taskIndex].isCompleted}",
        tag: "ProjectCubit");
  }

  void statusChange(TaskStatus status) {
    DebugLogger.log("statusChange called with status: $status",
        tag: "ProjectCubit");
    final updateProject = _currentFormState.project.copyWith(status: status);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        ProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with status: ${formState.status}",
        tag: "ProjectCubit");
  }

  void submitForm() {
    DebugLogger.log('submitForm called', tag: 'ProjectCubit');

    final formState = _currentFormState;

    if (!formState.isValid) {
      DebugLogger.logError("Form is not valid, cannot submit",
          context: "ProjectCubit");
      return;
    }

    final project = formState.project;

    initialProject == null
        ? addProject(project: project)
        : editProject(project: project);
  }

  Future<void> editProject({required ProjectModel project}) async {
    var result = await projectRepo.editProject(updatedProject: project);

    result.fold((errMessage) => emit(ProjectError(errMessage)),
        (_) => emit(ProjectSuccess()));
  }

  Future<void> addProject({required ProjectModel project}) async {
    var result = await projectRepo.addProject(project: project);

    result.fold((errMessage) => emit(ProjectError(errMessage)),
        (_) => emit(ProjectSuccess()));
  }
}
