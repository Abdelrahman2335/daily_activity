import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debug_logger.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({
    super.key,
  });

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
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: state.projects.length,
              (ctx, index) => SizedBox(
                height: 109,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
                  child: ProjectCard(
                    data: state.projects[index],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is HomeError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(state.errMessage),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      listener: (BuildContext context, HomeState state) {
        DebugLogger.log("State is: $state");
      },
    );
  }
}
