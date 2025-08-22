part of 'project_cubit.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {}

final class ProjectSuccess extends ProjectState {}

final class ProjectError extends ProjectState {
  ProjectError(this.errMessage);
  final String errMessage;
}

final class ProjectFormState extends ProjectState {
  final ProjectModel project;
  final bool isValid;

  ProjectFormState({required this.project, this.isValid = false});

  ProjectFormState copyWith({ProjectModel? project, bool? isValid}) {
    return ProjectFormState(
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
