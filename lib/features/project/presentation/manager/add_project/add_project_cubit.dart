import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/features/home/data/data_sources/categories.dart';
import 'package:daily_activity/features/project/data/repository/project_repo.dart';
import 'package:meta/meta.dart';

part 'add_project_state.dart';

class AddProjectCubit extends Cubit<AddProjectState> {
  AddProjectCubit(this.projectRepo)
      : super(
          AddProjectFormState(
              project: ProjectModel(
                  title: "",
                  description: "",
                  category: categories[ProjectCategory.dailyStudy]!,
                  date: "",
                  tasks: [],
                  status: TaskStatus.notStarted),
              isValid: false),
        );

  final ProjectRepository projectRepo;

  Future<void> addProject({required ProjectModel project}) async {
    projectRepo.addProject(project: project);
  }
}
