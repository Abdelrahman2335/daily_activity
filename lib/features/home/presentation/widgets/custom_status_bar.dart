import 'package:daily_activity/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/project_status.dart';


class CustomStatusBar extends StatefulWidget {
  const CustomStatusBar({super.key});

  @override
  State<CustomStatusBar> createState() => _CustomStatusBarState();
}

class _CustomStatusBarState extends State<CustomStatusBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(TaskStatus.values.length, (index) {
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(left: 14),
              child: PrimaryButton(
                isSelected: isSelected,
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                text: TaskStatus.values[index].displayName,
              ),
            );
          }),
        ),
      ),
    );
  }
}
