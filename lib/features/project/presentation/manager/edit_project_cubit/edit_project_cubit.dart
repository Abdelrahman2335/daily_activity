import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo.dart';

import 'package:meta/meta.dart';

part 'edit_project_state.dart';

class EditProjectCubit extends Cubit<EditProjectState> {
  EditProjectCubit(this.projectRepo, {required ProjectModel initialProject})
      : super(
          EditProjectFormState(
              project: initialProject,
              isValid:
                  true), // Start with true since we have an existing project
        );

  final ProjectRepository projectRepo;

  EditProjectFormState get _currentFormState {
    final currentState = state;
    if (currentState is EditProjectFormState) {
      return currentState;
    }
    // This shouldn't happen in normal flow, but providing fallback
    return EditProjectFormState(
        project: ProjectModel(
          title: "",
          description: "",
          category: categories[ProjectCategory.dailyStudy]!,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          tasks: [],
          status: TaskStatus.notStarted,
        ),
        isValid: false);
  }

  bool _validForm(EditProjectFormState state) {
    bool isValid = state.description.isNotEmpty &&
        state.title.isNotEmpty &&
        state.tasks.isNotEmpty;
    DebugLogger.log("validForm is: $isValid");

    return isValid;
  }

  void titleChange(String title) {
    DebugLogger.log("titleChange called with Title: $title",
        tag: "EditProjectCubit");

    final updateProject = _currentFormState.project.copyWith(title: title);
    final formState = EditProjectFormState(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
      ),
    );
    emit(formState);
    DebugLogger.log("emit new state with title: ${formState.title}",
        tag: "EditProjectCubit");
  }

  void descriptionChange(String description) {
    DebugLogger.log("descriptionChange called with description: $description",
        tag: "EditProjectCubit");

    final updateProject =
        _currentFormState.project.copyWith(description: description);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(EditProjectFormState(project: updateProject)),
    );
    emit(formState);
    DebugLogger.log("emit new state with description: ${formState.description}",
        tag: "EditProjectCubit");
  }

  void categoryChange(ProjectCategoryModel category) {
    DebugLogger.log("categoryChange called with category: $category",
        tag: "EditProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(category: category);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with category: ${formState.category.title}",
        tag: "EditProjectCubit");
  }

  void startDateChange(DateTime startDate) {
    DebugLogger.log("startDateChange called with startDate: $startDate",
        tag: "EditProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(startDate: startDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with startDate: ${formState.startDate}",
        tag: "EditProjectCubit");
  }

  void endDateChange(DateTime endDate) {
    DebugLogger.log("endDateChange called with endDate: $endDate",
        tag: "EditProjectCubit");
    final updateProject = _currentFormState.project.copyWith(endDate: endDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with endDate: ${formState.endDate}",
        tag: "EditProjectCubit");
  }

  void tasksChange(TaskModel task) {
    DebugLogger.log("tasksChange called with tasks: $task",
        tag: "EditProjectCubit");

    List<TaskModel> updatedTasks = List.from(_currentFormState.project.tasks);

    int existingIndex = updatedTasks.indexWhere((i) => i.id == task.id);
    updatedTasks[existingIndex] = task;

    final updateProject =
        _currentFormState.project.copyWith(tasks: updatedTasks);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
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
        tag: "EditProjectCubit");
  }

  void statusChange(TaskStatus status) {
    DebugLogger.log("statusChange called with status: $status",
        tag: "EditProjectCubit");
    final updateProject = _currentFormState.project.copyWith(status: status);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        EditProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with status: ${formState.status}",
        tag: "EditProjectCubit");
  }

  void submitForm() {
    DebugLogger.log('submitForm called', tag: 'EditProjectCubit');

    final formState = _currentFormState;

    if (!formState.isValid) {
      DebugLogger.logError("Form is not valid, cannot submit",
          context: "EditProjectCubit");
      return;
    }

    final project = formState.project;

    editProject(project: project);
  }

  Future<void> editProject({required ProjectModel project}) async {
    var result = await projectRepo.editProject(updatedProject: project);

    result.fold((errMessage) => emit(EditProjectError(errMessage)),
        (_) => emit(EditProjectSuccess()));
  }
}
