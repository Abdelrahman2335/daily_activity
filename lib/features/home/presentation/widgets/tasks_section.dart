import 'package:daily_activity/features/home/data/data_sources/dummy_data.dart';
import 'package:daily_activity/features/home/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: dummyTasks.length,
        (ctx, index) => SizedBox(
          height: 109,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
            child: TaskCard(
              data: dummyTasks[index],
            ),
          ),
        ),
      ),
    );
  }
}
