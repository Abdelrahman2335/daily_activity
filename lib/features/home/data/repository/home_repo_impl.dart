import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class HomeRepoImpl implements HomeRepo {
  @override
  Either<String, List<ProjectModel>> getProjects() {
    try {
      final projects =
          Hive.box<ProjectModel>(Constants.kMainBox).values.toList();

      final sortedProjects = projects
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      return Right(sortedProjects);
    } catch (e) {
      DebugLogger.log("Error Cached in the HomeRepoImpl");
      return Left(e.toString());
    }
  }

  @override
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Either<String, List<ProjectModel>> dateFilter(
      DateTime currentDate, List<ProjectModel> projects) {
    try {
      final filteredProjects = projects.where((p) {
        return (p.startDate.isBefore(currentDate) &&
                p.endDate.isAfter(currentDate)) ||
            isSameDate(p.startDate, currentDate) ||
            isSameDate(p.endDate, currentDate);
      }).toList();
      final sortedProjects = filteredProjects
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      return Right(sortedProjects);
    } catch (e) {
      DebugLogger.log("Error Cached in the HomeRepoImpl");
      return Left(e.toString());
    }
  }

  @override
  Either<String, List<ProjectModel>> statusFilter(TaskStatus status) {
    try {
      final projects =
          Hive.box<ProjectModel>(Constants.kMainBox).values.toList();

      final sortedProjects = projects
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

      final filteredProjects =
          sortedProjects.where((p) => p.status == status).toList();

      return Right(filteredProjects);
    } catch (e) {
      DebugLogger.log("Error Cached in the HomeRepoImpl");
      return Left(e.toString());
    }
  }
}
