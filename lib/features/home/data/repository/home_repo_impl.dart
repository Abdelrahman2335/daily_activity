import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class HomeRepoImpl implements HomeRepo {
  final _projects = Hive.box<ProjectModel>(Constants.kMainBox).values.toList();
  @override
  Either<String, List<ProjectModel>> getProjects() {
    try {
      final sortedProjects = _projects
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
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
    DateTime currentDate,
  ) {
    try {
      final filteredProjects = _projects.where((p) {
        return (p.startDate.isBefore(currentDate) &&
                p.endDate.isAfter(currentDate)) ||
            isSameDate(p.startDate, currentDate) ||
            isSameDate(p.endDate, currentDate);
      }).toList();
      final sortedProjects = filteredProjects
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
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
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

      final filteredProjects =
          sortedProjects.where((p) => p.status == status).toList();

      return Right(filteredProjects);
    } catch (e) {
      DebugLogger.log("Error Cached in the HomeRepoImpl");
      return Left(e.toString());
    }
  }

  @override
  String getOverallProgress() {
    final totalTasks = _projects.fold<int>(0, (sum, t) => sum + t.tasks.length);
    if (totalTasks == 0) return '0';

    final completedTasks = _projects.fold<int>(
        0,
        (sum, project) =>
            sum + project.tasks.where((t) => t.isCompleted ?? false).length);
    final percentValue = (completedTasks / totalTasks) * 100;
    if (percentValue == 0) {
      return '0';
    } else if (percentValue == percentValue.roundToDouble()) {
      return percentValue.toInt().toString();
    } else {
      return percentValue.toStringAsFixed(1);
    }
  }

  @override
  String progressValue(ProjectModel project) {
    final percentValue = project.progress * 100;
    if (percentValue == 0) {
      return '0%';
    } else if (percentValue == percentValue.roundToDouble()) {
      return '${percentValue.toInt()}%';
    } else {
      return '${percentValue.toStringAsFixed(1)}%';
    }
  }
}
