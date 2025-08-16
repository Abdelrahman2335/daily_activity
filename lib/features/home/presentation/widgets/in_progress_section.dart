import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:daily_activity/features/home/presentation/widgets/in_progress_todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InProgressSection extends StatelessWidget {
  const InProgressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // SliverList does not support horizontal scrolling directly,
    List<ProjectModel> projects = [];
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeFiltered) {
          projects = state.projects;
        }
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
                itemCount: projects.length,
                itemBuilder: (BuildContext context, int index) {
                  return InProgressTodo(
                    data: projects[index],
                  );
                }),
          ),
        );
      },
    );
  }
}
