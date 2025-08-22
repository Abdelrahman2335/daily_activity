import 'package:daily_activity/features/home/presentation/widgets/custom_calender_list.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_status_bar.dart';
import 'package:daily_activity/features/home/presentation/widgets/filtered_projects.dart';
import 'package:daily_activity/core/widgets/project_app_bar.dart';
import 'package:flutter/material.dart';

class TodayTaskViewBody extends StatelessWidget {
  const TodayTaskViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: ProjectAppBar(
          title: "Projects",
          onActionButtonPressed: () {},
        )),
        const CustomCalenderList(),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const CustomStatusBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const FilteredProjects(),
      ],
    );
  }
}
