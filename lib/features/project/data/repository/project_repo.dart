import 'package:daily_activity/core/models/project_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectRepository {
  Future<Either<String, void>> addProject({required ProjectModel project});
  Future<Either<String, void>> editProject(
      {required ProjectModel updatedProject});
}
