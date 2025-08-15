import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({
    super.key,
    required this.projects,
  });

  final List<ProjectModel> projects;
  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getDate();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.projects.length,
        (ctx, index) => SizedBox(
          height: 109,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
            child: ProjectCard(
              data: widget.projects[index],
              onTap: () {
                DebugLogger.log("${widget.projects[index].status}");
              },
            ),
          ),
        ),
      ),
    );
  }
}
