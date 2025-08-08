part of 'add_project_cubit.dart';

@immutable
sealed class AddProjectState {}

final class AddProjectInitial extends AddProjectState {}

final class AddProjectLoading extends AddProjectState {}

final class AddProjectSuccess extends AddProjectState {

}

final class AddProjectError extends AddProjectState {
  AddProjectError(this.errMessage);
  final String errMessage;
}

final class AddProjectFormState extends AddProjectState {
  final ProjectModel project;
  final bool isValid;

  AddProjectFormState({required this.project, this.isValid = false});

  AddProjectFormState copyWith({ProjectModel? project, bool? isValid}) {
    return AddProjectFormState(
        project: project ?? this.project, isValid: isValid ?? this.isValid);
  }

  String get title => project.title;
  String get description => project.description;
  ProjectCategoryModel get category => project.category;
  String get startDate => project.startDate;
  String get endDate => project.endDate;
  String get date => project.startDate;
  int get progress => project.progress;
  TaskStatus get status => project.status;
  List<String> get tasks => project.tasks;
}
