import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/utils/app_router.dart';
import 'package:flowi/features/home/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({
    super.key,
    required this.projects,
  });

  final List<ProjectModel> projects;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: projects.length,
        (ctx, index) => SizedBox(
          height: 109, // Hard code
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
