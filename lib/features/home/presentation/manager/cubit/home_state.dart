part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  HomeSuccess(this.projects);
  final List<ProjectModel> projects;
}

class HomeFiltered extends HomeState {
  final List<ProjectModel> projects;
  final FilterType filterType;
  HomeFiltered(this.projects, this.filterType);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

enum FilterType { date, status }
