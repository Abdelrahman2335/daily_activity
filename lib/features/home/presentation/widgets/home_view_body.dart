import 'package:daily_activity/features/home/presentation/widgets/home_app_bar.dart';
import 'package:daily_activity/features/home/presentation/widgets/in_progress_section.dart';
import 'package:daily_activity/features/home/presentation/widgets/overview_section.dart';
import 'package:daily_activity/features/home/presentation/widgets/tasks_section.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_text_styles.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeAppBar(),
        const OverviewSection(),
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
        const InProgressSection(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 19, bottom: 11, top: 11),
            child: Text(
              "Tasks",
              style: AppTextStyles.textStyle19,
            ),
          ),
        ),
        const TasksSection(),
      ],
    );
  }
}
