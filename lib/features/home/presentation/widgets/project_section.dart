import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/features/home/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({
    super.key,
    required this.projects,
  });

  final List<ProjectModel> projects;
  @override
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: projects.length,
        (ctx, index) => SizedBox(
          height: 109,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
            child: ProjectCard(
              data: projects[index],
              onTap: () {
                GoRouter.of(context)
                    .push(AppRouter.kEditProject, extra: projects[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
