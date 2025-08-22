import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/models/data_time_model.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());
  final HomeRepo homeRepo;

  List<ProjectModel> _allProjects = [];

  void loadProjects() {
    emit(HomeLoading());
    final result = homeRepo.getProjects();
    result.fold(
      (error) => emit(HomeError(error)),
      (projects) {
        _allProjects = projects;
        emit(HomeSuccess(projects));
      },
    );
  }

  void applyDateFilter(DateTime currentDate) {
    if (_allProjects.isEmpty) {
      loadProjects();
      return;
    }

    emit(HomeLoading());
    final result = homeRepo.dateFilter(currentDate);
    result.fold(
      (error) => emit(HomeError(error)),
      (projects) => emit(HomeFiltered(projects, FilterType.date)),
    );
  }

  void applyStatusFilter(TaskStatus status) {
    if (_allProjects.isEmpty) {
      loadProjects();
      return;
    }

    emit(HomeLoading());
    final result = homeRepo.statusFilter(status);
    result.fold(
      (error) => emit(HomeError(error)),
      (projects) => emit(HomeFiltered(projects, FilterType.status)),
    );
  }

  List<ProjectModel> get inProgressProjects {
    final result = homeRepo.statusFilter(TaskStatus.inProgress);
    return result.fold(
      (error) {
        DebugLogger.log('inProgressProjects error: $error');
        return const <ProjectModel>[];
      },
      (projects) => List.unmodifiable(projects),
    );
  }

  void clearFilters() {
    emit(HomeSuccess(_allProjects));
  }

  bool get hasProjectsInProgress {
    final result = homeRepo.statusFilter(TaskStatus.inProgress);
    var hasProjects = result.fold((_) => false, (projects) => projects.isNotEmpty);
    return hasProjects;
  }

  List<DateTime> get dateTimeList => homeRepo.dateTimeList();

  List<DataTimeModel> get customDateList {
    return dateTimeList
        .map((d) => DataTimeModel(
              month: d.month,
              day: d.day,
              weekday: d.weekday,
            ))
        .toList();
  }

  String get overallProgress => homeRepo.getOverallProgress();

  String progressValue(ProjectModel project) => homeRepo.progressValue(project);
}
