part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  HomeSuccess(this.projects);
  final List<ProjectModel> projects;
}

final class HomeFilter extends HomeState {
  HomeFilter(this.projects);
  final List<ProjectModel> projects;
}

final class HomeError extends HomeState {
  HomeError(this.errMessage);
  final String errMessage;
}
