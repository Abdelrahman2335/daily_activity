import 'package:bloc/bloc.dart';
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

  void dateFilter(DateTime currentDate, List<ProjectModel> projects) {
    emit(HomeLoading());

    var result = homeRepo.dateFilter(currentDate, projects);

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeFilter(projects)));
  }

  void statusFilter(TaskStatus status, List<ProjectModel> projects) {
    emit(HomeLoading());

    var result = homeRepo.statusFilter(status, projects);

    result.fold((error) => emit(HomeError(error)),
        (projects) => emit(HomeFilter(projects)));
  }
}
