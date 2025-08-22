import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/home/data/repository/home_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class HomeRepoImpl implements HomeRepo {
  List<ProjectModel> get _projects =>
      Hive.box<ProjectModel>(Constants.kMainBox).values.toList();

  List<ProjectModel> _sortProjectsByDate(List<ProjectModel> projects) {
    return List.from(projects)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  List<ProjectModel> _sortProjectsByLastModified(List<ProjectModel> projects) {
    return List.from(projects)
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  Either<String, T> _handleError<T>(String operation, dynamic error) {
    DebugLogger.log("Error in HomeRepoImpl.$operation: $error");
    return Left("Failed to $operation: ${error.toString()}");
  }

  @override
  Either<String, List<ProjectModel>> getProjects() {
    try {
      final sortedProjects = _sortProjectsByLastModified(_projects);
      return Right(sortedProjects);
    } catch (e) {
      return _handleError('get projects', e);
    }
  }

  @override
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Either<String, List<ProjectModel>> dateFilter(DateTime currentDate) {
    try {
      final filteredProjects = _projects.where((project) {
        return (project.startDate.isBefore(currentDate) &&
                project.endDate.isAfter(currentDate)) ||
            isSameDate(project.startDate, currentDate) ||
            isSameDate(project.endDate, currentDate);
      }).toList();

      final sortedProjects = _sortProjectsByDate(filteredProjects);
      return Right(sortedProjects);
    } catch (e) {
      return _handleError('filter projects by date', e);
    }
  }

  @override
  List<DateTime> dateTimeList() {
    try {
      if (_projects.isEmpty) return [];

      final sortedProjects = _sortProjectsByDate(_projects);

      final startDate = sortedProjects
          .map((p) => p.startDate)
          .reduce((a, b) => a.isBefore(b) ? a : b);

      final endDate = sortedProjects
          .map((p) => p.endDate)
          .reduce((a, b) => a.isAfter(b) ? a : b);

      final dateList = <DateTime>[];
      DateTime currentDate =
          DateTime(startDate.year, startDate.month, startDate.day);
      final finalDate = DateTime(endDate.year, endDate.month, endDate.day);

      while (!currentDate.isAfter(finalDate)) {
        dateList.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }

      return dateList;
    } catch (e) {
      DebugLogger.log("Error in HomeRepoImpl.dateTimeList: $e");
      return [];
    }
  }

  @override
  Either<String, List<ProjectModel>> statusFilter(TaskStatus status) {
    try {
      final sortedProjects = _sortProjectsByDate(_projects);
      final filteredProjects =
          sortedProjects.where((project) => project.status == status).toList();

      return Right(filteredProjects);
    } catch (e) {
      return _handleError('filter projects by status', e);
    }
  }

  @override
  String getOverallProgress() {
    try {
      final totalTasks = _projects.fold<int>(
        0,
        (sum, project) => sum + project.tasks.length,
      );

      if (totalTasks == 0) return '0';

      final completedTasks = _projects.fold<int>(
        0,
        (sum, project) =>
            sum +
            project.tasks.where((task) => task.isCompleted == true).length,
      );

      return _formatPercentage(completedTasks / totalTasks * 100,
          includePercent: false);
    } catch (e) {
      DebugLogger.log("Error in HomeRepoImpl.getOverallProgress: $e");
      return "0";
    }
  }

  @override
  String progressValue(ProjectModel project) {
    try {
      if (project.progress < 0 || project.progress > 1) {
        DebugLogger.log("Invalid progress value: ${project.progress}");
        return "0%";
      }

      return _formatPercentage(project.progress * 100, includePercent: true);
    } catch (e) {
      DebugLogger.log("Error in HomeRepoImpl.progressValue: $e");
      return "0%";
    }
  }

  /// Helper method to format percentage values consistently
  String _formatPercentage(double value, {required bool includePercent}) {
    final suffix = includePercent ? '%' : '';

    if (value == 0) {
      return '0$suffix';
    } else if (value == value.roundToDouble()) {
      return '${value.toInt()}$suffix';
    } else {
      return '${value.toStringAsFixed(1)}$suffix';
    }
  }
}
