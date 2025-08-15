import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo.dart';

import 'package:meta/meta.dart';

part 'add_project_state.dart';

class AddProjectCubit extends Cubit<AddProjectState> {
  AddProjectCubit(this.projectRepo)
      : super(
          AddProjectFormState(
              project: ProjectModel(
                title: "",
                description: "",
                category: categories[ProjectCategory.dailyStudy]!,
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                tasks: [],
                status: TaskStatus.notStarted,
              ),
              isValid: false),
        );

  final ProjectRepository projectRepo;

  AddProjectFormState get _currentFormState {
    final currentState = state;
    if (currentState is AddProjectFormState) {
      return currentState;
    }
    return AddProjectFormState(
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

  bool _validForm(AddProjectFormState state) {
    DebugLogger.log(
        "validForm called, startDate is: ${state.project.startDate}",
        tag: "AddProjectCubit");
    DebugLogger.log("validForm called, endDate is: ${state.project.endDate}",
        tag: "AddProjectCubit");
    DebugLogger.log(
        "validForm called, category is: ${state.project.category.title}",
        tag: "AddProjectCubit");
    DebugLogger.log("validForm called, title is: ${state.project.title}",
        tag: "AddProjectCubit");
    DebugLogger.log(
        "validForm called, description is: ${state.project.description}",
        tag: "AddProjectCubit");
    for (var i in state.project.tasks) {
      DebugLogger.log("validForm called, tasks is: ${i.title}");
    }

    bool isValid = state.description.isNotEmpty &&
        state.title.isNotEmpty &&
        state.tasks.isNotEmpty;

    return isValid;
  }

  void titleChange(String title) {
    DebugLogger.log("titleChange called with Title: $title",
        tag: "AddProjectCubit");

    final updateProject = _currentFormState.project.copyWith(title: title);
    final formState = AddProjectFormState(
      project: updateProject,
      isValid: _validForm(
        AddProjectFormState(project: updateProject),
      ),
    );
    emit(formState);
    DebugLogger.log("emit new state with title: ${formState.title}",
        tag: "AddProjectCubit");
  }

  void descriptionChange(String description) {
    DebugLogger.log("descriptionChange called with description: $description",
        tag: "AddProjectCubit");

    final updateProject =
        _currentFormState.project.copyWith(description: description);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(AddProjectFormState(project: updateProject)),
    );
    emit(formState);
    DebugLogger.log("emit new state with description: ${formState.description}",
        tag: "AddProjectCubit");
  }

  void categoryChange(ProjectCategoryModel category) {
    DebugLogger.log("categoryChange called with category: $category",
        tag: "AddProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(category: category);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        AddProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with category: ${formState.category.title}",
        tag: "AddProjectCubit");
  }

  void startDateChange(DateTime startDate) {
    DebugLogger.log("startDateChange called with startDate: $startDate",
        tag: "AddProjectCubit");
    final updateProject =
        _currentFormState.project.copyWith(startDate: startDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        AddProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with startDate: ${formState.startDate}",
        tag: "AddProjectCubit");
  }

  void endDateChange(DateTime endDate) {
    DebugLogger.log("endDateChange called with endDate: $endDate",
        tag: "AddProjectCubit");
    final updateProject = _currentFormState.project.copyWith(endDate: endDate);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        AddProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with endDate: ${formState.endDate}",
        tag: "AddProjectCubit");
  }

  void tasksChange(TaskModel task) {
    DebugLogger.log("tasksChange called with tasks: $task",
        tag: "AddProjectCubit");

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
        AddProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with tasks: ${formState.tasks}",
        tag: "AddProjectCubit");
  }

  void statusChange(TaskStatus status) {
    DebugLogger.log("statusChange called with status: $status",
        tag: "AddProjectCubit");
    final updateProject = _currentFormState.project.copyWith(status: status);
    final formState = _currentFormState.copyWith(
      project: updateProject,
      isValid: _validForm(
        AddProjectFormState(project: updateProject),
      ),
    );

    emit(formState);
    DebugLogger.log("emit new state with status: ${formState.status}",
        tag: "AddProjectCubit");
  }

  void submitForm() {
    DebugLogger.log('submitForm called', tag: 'AddCustomerCubit');

    final formState = _currentFormState;

    if (!formState.isValid) {
      DebugLogger.logError("Form is not valid, cannot submit",
          context: "AddProjectCubit");
      return;
    }

    final project = ProjectModel(
      title: formState.title,
      description: formState.description,
      category: formState.category,
      startDate: formState.startDate,
      endDate: formState.endDate,
      tasks: formState.tasks,
      status: TaskStatus.notStarted,
    );

    addProject(project: project);
  }

  Future<void> addProject({required ProjectModel project}) async {
    var result = await projectRepo.addProject(project: project);

    result.fold((errMessage) => emit(AddProjectError(errMessage)),
        (_) => emit(AddProjectSuccess()));
  }
}
