import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Either<String, List<ProjectModel>> getProjects();
  Either<String, List<ProjectModel>> statusFilter(
      TaskStatus  status, List<ProjectModel> projects);
  Either<String, List<ProjectModel>> dateFilter(
      DateTime currentDate, List<ProjectModel> projects);
}
