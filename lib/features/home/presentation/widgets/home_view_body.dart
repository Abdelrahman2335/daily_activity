import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_app_bar.dart';
import 'package:daily_activity/features/home/presentation/widgets/in_progress_section.dart';
import 'package:daily_activity/features/home/presentation/widgets/overview_section.dart';
import 'package:daily_activity/features/home/presentation/widgets/project_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/app_text_styles.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    bool hasProgress = context.read<HomeCubit>().hasProjectsInProgress;
    List<ProjectModel>? projects;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;
        if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.textStyle16,
            ),
          );
        }

        if (state is HomeSuccess) {
          projects = state.projects;
        }

        return Skeletonizer(
          enabled: isLoading,
          child: CustomScrollView(
            slivers: [
              const HomeAppBar(),
              const OverviewSection(),
              if (hasProgress)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 19,
                      bottom: 11,
                    ),
                    child: Text(
                      "In Progress",
                      style: AppTextStyles.textStyle19,
                    ),
                  ),
                ),
              if (hasProgress) const InProgressSection(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, bottom: 11, top: 11),
                  child: Text(
                    "Projects",
                    style: AppTextStyles.textStyle19,
                  ),
                ),
              ),
              ProjectSection(
                projects: projects ?? [],
              ),
            ],
          ),
        );
      },
    );
  }
}
