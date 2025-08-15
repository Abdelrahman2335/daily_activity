import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:daily_activity/features/home/presentation/widgets/in_progress_todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InProgressSection extends StatelessWidget {
  const InProgressSection({
    super.key,
    required this.projects,
  });
  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    // SliverList does not support horizontal scrolling directly,

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 170,
        width: double.infinity,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                crossAxisSpacing: 9,
                childAspectRatio: 0.8),
            itemCount: context.read<HomeCubit>().inProgressProjects().length,
            itemBuilder: (BuildContext context, int index) {
              return InProgressTodo(
                data: context.read<HomeCubit>().inProgressProjects()[index],
              );
            }),
      ),
    );
  }
}
