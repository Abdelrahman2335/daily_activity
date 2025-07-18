import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 9.0,
      backgroundColor: AppColor.primary,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      onPressed: () {
        // Add your action here
      },
      child: const Icon(Icons.add),
    );
  }
}
