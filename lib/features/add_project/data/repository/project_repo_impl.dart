import 'dart:developer';

import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/features/add_project/data/repository/project_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final Box box = Hive.box(Constants.kMainBox);
  @override
  Either<String, void> addProject({required ProjectModel project}) {
    try {
      box.put(project.id, project);
      return Right(null);
    } catch (error) {
      log("$error");

      return Left("An Error has occurs when adding the project");
    }
  }

  @override
  Either<String, void> editProject({required ProjectModel updatedProject}) {
    try {
      box.put(updatedProject.id, updatedProject);
      updatedProject.save();
      return Right(null);
    } catch (error) {
      log("$error");
      return Left("An Error has occurs when updating the project");
    }
  }
}
