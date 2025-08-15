import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  bool isSameDate(DateTime a, DateTime b);
  String progressValue(ProjectModel project);
  String getOverallProgress();
  List<DateTime> dateTimeList();
  Either<String, List<ProjectModel>> getProjects();
  Either<String, List<ProjectModel>> statusFilter(TaskStatus status);
  Either<String, List<ProjectModel>> dateFilter(DateTime currentDate);
}
