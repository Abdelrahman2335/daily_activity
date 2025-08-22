import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo_impl.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/add_project_view_body.dart';
import 'package:daily_activity/features/project/presentation/widgets/edit_project_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key, required this.isEditMood, this.project});

  final bool isEditMood;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log("isEditMood is: $isEditMood");
    DebugLogger.log("project is: ${project != null}");
    return BackgroundLayout(
      children: [
        if (isEditMood && project != null)
          BlocProvider<ProjectCubit>(
            create: (context) =>
                ProjectCubit(ProjectRepositoryImpl(), initialProject: project!),
            child: const EditProjectViewBody(),
          )
        else
          BlocProvider<ProjectCubit>(
            create: (context) =>
                ProjectCubit(ProjectRepositoryImpl(), initialProject: null),
            child: const AddProjectViewBody(),
          ),
      ],
    );
  }
}
