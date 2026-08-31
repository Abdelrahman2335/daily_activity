import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/home/presentation/widgets/home_app_bar.dart';
import 'package:flowi/features/home/presentation/widgets/in_progress_section.dart';
import 'package:flowi/features/home/presentation/widgets/overview_section.dart';
import 'package:flowi/features/home/presentation/widgets/project_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/app_text_styles.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;
        final hasProgress = context.read<HomeCubit>().hasProjectsInProgress;
        List<ProjectModel>? projects;

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
        } else if (state is HomeFiltered) {
          projects = state.projects;
        }

        return Stack(children: [
          Skeletonizer(
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
                        style: AppTextStyles.textStyle19(context),
                      ),
                    ),
                  ),
                if (hasProgress) const InProgressSection(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 19, bottom: 11, top: 11),
                    child: Text(
                      "Projects",
                      style: AppTextStyles.textStyle19(context),
                    ),
                  ),
                ),
                ProjectSection(
                  projects: projects ?? const [],
                ),
              ],
            ),
          ),

          // Disable Ai chat
          // Positioned(
          //   bottom: 20, // Above the navigation bar
          //   right: 16,
          //   child: FloatingActionButton(
          //     backgroundColor: Theme.of(context).colorScheme.surface,
          //     shape: const CircleBorder(),
          //     heroTag: "geminiAi",
          //     onPressed: () {
          //       GoRouter.of(context).push(AppRouter.kAiAssistant);
          //     },
          //     child: SvgPicture.asset(
          //       Assets.geminiAi,
          //       width: 28,
          //       height: 28,
          //     ),
          //   ),
          // ),
        ]);
      },
    );
  }
}
