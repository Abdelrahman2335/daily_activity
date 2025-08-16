import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo_impl.dart';
import 'package:daily_activity/features/project/presentation/manager/add_project_cubit/add_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/manager/edit_project_cubit/edit_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/project_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key, required this.isEditMood, this.project});

  final bool isEditMood;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      children: [
        if (isEditMood && project != null)
          BlocProvider<EditProjectCubit>(
            create: (context) => EditProjectCubit(ProjectRepositoryImpl(),
                initialProject: project!),
            child: const ProjectViewBody(),
          )
        else
          BlocProvider<AddProjectCubit>(
            create: (context) => AddProjectCubit(ProjectRepositoryImpl()),
            child: const ProjectViewBody(),
          ),
      ],
    );
  }
}
