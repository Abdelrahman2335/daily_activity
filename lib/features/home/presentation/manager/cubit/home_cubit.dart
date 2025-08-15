import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());
  final HomeRepo homeRepo;

  String progressValue(ProjectModel data) {
    final percentValue = data.progress * 100;
    if (percentValue == 0) {
      return '0%';
    } else if (percentValue == percentValue.roundToDouble()) {
      return '${percentValue.toInt()}%';
    } else {
      return '${percentValue.toStringAsFixed(1)}%';
    }
  }

  void getDate() {
    emit(HomeLoading());

    var result = homeRepo.getProjects();

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeSuccess(projects)));
  }

  void dateFilter(DateTime currentDate, List<ProjectModel> projects) {
    emit(HomeLoading());

    var result = homeRepo.dateFilter(currentDate, projects);

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
}
