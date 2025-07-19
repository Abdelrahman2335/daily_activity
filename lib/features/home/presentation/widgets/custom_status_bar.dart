
import 'package:daily_activity/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class CustomStatusBar extends StatefulWidget {
  const CustomStatusBar({super.key});

  @override
  State<CustomStatusBar> createState() => _CustomStatusBarState();
}

class _CustomStatusBarState extends State<CustomStatusBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> buttonLabels = ['All', 'In Progress', 'Completed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(buttonLabels.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: PrimaryButton(
              isSelected: isSelected,
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              text: buttonLabels[index],
            ),
          );
        }),
      ),
    );
  }
}
