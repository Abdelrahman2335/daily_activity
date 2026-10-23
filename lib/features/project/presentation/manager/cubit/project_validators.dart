import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/task_model.dart';

/// Single source of truth for project form validation.
///
/// Both [ProjectCubit] (which guards `submitForm`) and the form widgets
/// (which render `TextFormField` errors) use these rules, so the cubit guard
/// and the UI guard can never disagree about what a valid project is.
class ProjectValidators {
  const ProjectValidators._();

  static const String requiredMessage = 'Field is required';

  /// Validator for a single required text field.
  /// Returns `null` when the value has non-whitespace content.
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    return null;
  }

  static bool isTitleValid(String title) => requiredField(title) == null;

  static bool isDescriptionValid(String description) =>
      requiredField(description) == null;

  static bool isTaskTitleValid(String title) => requiredField(title) == null;

  /// A project needs at least one task, and every task needs a title.
  static bool isTaskListValid(List<TaskModel> tasks) =>
      tasks.isNotEmpty && tasks.every((task) => isTaskTitleValid(task.title));

  /// Full form validity, mirroring what the UI enforces field by field.
  static bool isFormValid(ProjectModel project) =>
      isTitleValid(project.title) &&
      isDescriptionValid(project.description) &&
      isTaskListValid(project.tasks);
}
