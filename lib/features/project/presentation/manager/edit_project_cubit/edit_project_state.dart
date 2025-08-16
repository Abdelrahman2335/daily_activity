part of 'edit_project_cubit.dart';

@immutable
sealed class EditProjectState {}

final class EditProjectInitial extends EditProjectState {}

final class EditProjectLoading extends EditProjectState {}

final class EditProjectSuccess extends EditProjectState {}

final class EditProjectError extends EditProjectState {
  EditProjectError(this.errMessage);
  final String errMessage;
}

final class EditProjectFormState extends EditProjectState {
  final ProjectModel project;
  final bool isValid;

  EditProjectFormState({required this.project, this.isValid = false});

  EditProjectFormState copyWith({ProjectModel? project, bool? isValid}) {
    return EditProjectFormState(
        project: project ?? this.project, isValid: isValid ?? this.isValid);
  }

  String get title => project.title;
  String get description => project.description;
  ProjectCategoryModel get category => project.category;
  DateTime get startDate => project.startDate;
  DateTime get endDate => project.endDate;
  DateTime get date => project.startDate;
  double get progress => project.progress;
  TaskStatus get status => project.status;
  List<TaskModel> get tasks => project.tasks;
}
