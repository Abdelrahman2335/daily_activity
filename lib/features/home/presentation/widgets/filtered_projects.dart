import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_today_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/models/project_model.dart';

class FilteredProjects extends StatelessWidget {
  const FilteredProjects({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<ProjectModel> displayedProjects = [];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;
        if (state is HomeFiltered) {
          displayedProjects = state.projects;
        } else if (state is HomeSuccess) {
          displayedProjects = state.projects;
        }
        if (isLoading) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Skeletonizer(
                enabled: true,
                child: Column(
                  children: List.generate(
                    5,
                    (i) => CustomTodayTaskCard(
                        project: displayedProjects, index: 5),
                  ),
                ),
              ),
            ),
          );
        }
        return SliverList.builder(
            itemCount: displayedProjects.length,
            itemBuilder: (context, index) {
              return CustomTodayTaskCard(
                  project: displayedProjects, index: index);
            });
      },
    );
  }
}
