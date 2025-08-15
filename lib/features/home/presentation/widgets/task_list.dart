import 'package:daily_activity/core/data/dummy_data.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_today_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/models/project_model.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<ProjectModel> taskModel = dummyTasks;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;
        if (state is HomeFilter) {
          taskModel = state.projects;
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
                    (i) => CustomTodayTaskCard(taskModel: taskModel, index: 5),
                  ),
                ),
              ),
            ),
          );
        }
        return SliverList.builder(
            itemCount: taskModel.length,
            itemBuilder: (context, index) {
              return CustomTodayTaskCard(taskModel: taskModel, index: index);
            });
      },
    );
  }
}
