import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/services/notification_service.dart';
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
    final reminder =
        _initialReminderFields(project);
    return ProjectFormState(
      project: initial,
      isValid: ProjectValidators.isFormValid(initial),
      reminderMode: reminder.mode,
      reminderCadence: reminder.cadence,
      customSlots: reminder.slots,
      customWeekdays: reminder.weekdays,
      weeklyTime: reminder.weeklyTime,
    );
  }

  /// Derives the form's reminder fields from an existing project. New
  /// drafts start on the default follow-global mode.
  static ({
    String mode,
    ReminderCadence cadence,
    List<String> slots,
    List<int> weekdays,
    String weeklyTime,
  }) _initialReminderFields(ProjectModel? project) {
    if (project == null || project.reminderMode == null) {
      return (
        mode: 'default',
        cadence: ReminderCadence.daily,
        slots: const <String>[],
        weekdays: const <int>[],
        weeklyTime: '09:00',
      );
    }

    switch (project.reminderMode) {
      case 'custom':
        final weekdays = project.customWeekdays ?? const <int>[];
        if (weekdays.isNotEmpty) {
          return (
            mode: 'custom',
            cadence: ReminderCadence.weekly,
            slots: const <String>[],
            weekdays: weekdays,
            weeklyTime: project.customSlots?.first ?? '09:00',
          );
        }
        return (
          mode: 'custom',
          cadence: ReminderCadence.daily,
          slots: List<String>.from(project.customSlots ?? const <String>[]),
          weekdays: const <int>[],
          weeklyTime: '09:00',
        );
      case 'off':
        return (
          mode: 'off',
          cadence: ReminderCadence.daily,
          slots: const <String>[],
          weekdays: const <int>[],
          weeklyTime: '09:00',
        );
      default:
        return (
          mode: 'default',
          cadence: ReminderCadence.daily,
          slots: const <String>[],
          weekdays: const <int>[],
          weeklyTime: '09:00',
        );
    }
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
  ///
  /// Reminder fields are carried from [carry] (which defaults to the current
  /// state) because [ProjectModel.copyWith] cannot write the nullable
  /// reminder fields back to null.
  void _emitForm(ProjectModel project,
      {String? logMessage, ProjectFormState? carry}) {
    final previous = carry ?? _currentFormState;
    emit(ProjectFormState(
      project: project,
      isValid: ProjectValidators.isFormValid(project),
      reminderMode: previous.reminderMode,
      reminderCadence: previous.reminderCadence,
      customSlots: previous.customSlots,
      customWeekdays: previous.customWeekdays,
      weeklyTime: previous.weeklyTime,
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

  // ---------------------------------------------------------------------------
  // Reminder form mutators (per-project override)
  // ---------------------------------------------------------------------------

  void reminderModeChange(String mode) {
    DebugLogger.log("reminderModeChange called with mode: $mode",
        tag: "ProjectCubit");

    final current = _currentFormState;
    _emitForm(
      current.project,
      logMessage: "reminderMode: $mode",
      carry: current.copyWith(reminderMode: mode),
    );
  }

  void reminderCadenceChange(ReminderCadence cadence) {
    DebugLogger.log("reminderCadenceChange called with cadence: $cadence",
        tag: "ProjectCubit");

    final current = _currentFormState;
    _emitForm(
      current.project,
      logMessage: "reminderCadence: $cadence",
      carry: current.copyWith(reminderCadence: cadence),
    );
  }

  void reminderDailySlotsChange(List<String> slots) {
    final current = _currentFormState;
    _emitForm(
      current.project,
      logMessage: "customSlots: $slots",
      carry: current.copyWith(customSlots: List<String>.from(slots)),
    );
  }

  void reminderWeeklyDaysChange(List<int> days) {
    final current = _currentFormState;
    _emitForm(
      current.project,
      logMessage: "customWeekdays: $days",
      carry: current.copyWith(customWeekdays: List<int>.from(days)),
    );
  }

  void reminderWeeklyTimeChange(String time) {
    final current = _currentFormState;
    _emitForm(
      current.project,
      logMessage: "weeklyTime: $time",
      carry: current.copyWith(weeklyTime: time),
    );
  }

  /// Normalizes the form's reminder fields into the persisted model fields:
  ///  * 'custom' weekly → customSlots = [weeklyTime], customWeekdays set,
  ///  * 'custom' daily  → customSlots = times, customWeekdays = null
  ///    (copyWith cannot write null, so a rebuild is needed when the base
  ///    model still carries weekly weekdays),
  ///  * 'default'/'off' → reminderMode only; stale slots are ignored by the
  ///    resolver.
  ProjectModel _applyReminderToModel(ProjectFormState form) {
    final base = form.project;
    switch (form.reminderMode) {
      case 'custom':
        if (form.reminderCadence == ReminderCadence.weekly) {
          return base.copyWith(
            reminderMode: 'custom',
            customSlots: [form.weeklyTime],
            customWeekdays: List<int>.from(form.customWeekdays),
          );
        }
        if (base.customWeekdays == null) {
          return base.copyWith(
            reminderMode: 'custom',
            customSlots: List<String>.from(form.customSlots),
          );
        }
        return ProjectModel(
          id: base.id,
          title: base.title,
          description: base.description,
          category: base.category,
          startDate: base.startDate,
          endDate: base.endDate,
          status: base.status,
          tasks: base.tasks,
          lastModified: DateTime.now(),
          reminderMode: 'custom',
          customSlots: List<String>.from(form.customSlots),
        );
      case 'off':
        return base.copyWith(reminderMode: 'off');
      default:
        return base.copyWith(reminderMode: 'default');
    }
  }

  /// Rebuilds the schedule after a project mutation. Fire-and-forget and
  /// failure-tolerant: reminder plumbing must never break an edit.
  void _resyncAfterMutation() {
    try {
      if (NotificationService.instance.isReady) {
        unawaited(NotificationService.instance.resync());
      }
    } catch (error) {
      DebugLogger.log("Reminder resync after mutation failed: $error",
          tag: "ProjectCubit");
    }
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

    final project = _applyReminderToModel(formState);

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
      _resyncAfterMutation();
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
      _resyncAfterMutation();
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
      _resyncAfterMutation();
      return true;
    });
  }
}
