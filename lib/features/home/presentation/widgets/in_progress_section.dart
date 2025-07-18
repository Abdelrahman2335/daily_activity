import 'package:daily_activity/features/home/data/data_sources/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:daily_activity/features/home/presentation/widgets/in_progress_todo.dart';

class InProgressSection extends StatelessWidget {
  const InProgressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // SliverList does not support horizontal scrolling directly,
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.21,
        width: double.infinity,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                crossAxisSpacing: 9,
                childAspectRatio: 0.8),
            itemCount: dummyTasks.length,
            itemBuilder: (BuildContext context, int index) {
              return InProgressTodo(
                data: dummyTasks[index],
              );
            }),
      ),
    );
  }
}
