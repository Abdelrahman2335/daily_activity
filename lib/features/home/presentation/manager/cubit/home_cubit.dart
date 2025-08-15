import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/models/data_time_model.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());
  final HomeRepo homeRepo;

  void getDate() {
    emit(HomeLoading());

    var result = homeRepo.getProjects();

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeSuccess(projects)));
  }

  List<DateTime> dateTimeList() {
    List<DateTime> dateTimeList = homeRepo.dateTimeList();

    return dateTimeList;
  }

  List<DataTimeModel> get getCustomDateList {
    List<DataTimeModel> dailyDataTimes = [];
    dateTimeList()
        .map(
          (d) => dailyDataTimes.add(
            DataTimeModel(month: d.month, day: d.day, weekday: d.weekday),
          ),
        )
        .toList();
    return dailyDataTimes;
  }

  void dateFilter(DateTime currentDate) {
    emit(HomeLoading());

    var result = homeRepo.dateFilter(currentDate);

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeFilter(projects)));
  }

  void statusFilter(TaskStatus status) {
    emit(HomeLoading());

    var result = homeRepo.statusFilter(status);

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeFilter(projects)));
  }

  List<ProjectModel> inProgressProjects() {
    List<ProjectModel> projects = [];
    var result = homeRepo.statusFilter(TaskStatus.inProgress);

    result.fold((error) => emit(HomeError(error)), (list) {
      projects = list;
      HomeFilter(list);
    });

    return projects;
  }

  String getOverallProgress() {
    return homeRepo.getOverallProgress();
  }

  String progressValue(ProjectModel project) {
    return homeRepo.progressValue(project);
  }
}
