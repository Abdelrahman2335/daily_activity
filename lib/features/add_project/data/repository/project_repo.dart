import 'package:daily_activity/core/models/project_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectRepository {
  Either<String, void> addProject({required ProjectModel project});
  Either<String, void> editProject({required ProjectModel updatedProject});
}
