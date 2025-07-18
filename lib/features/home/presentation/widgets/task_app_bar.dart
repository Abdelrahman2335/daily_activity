import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class TaskAppBar extends StatelessWidget {
  const TaskAppBar({
    super.key,
    required this.title,
    required this.actionButton,
    required this.onActionButtonPressed,
  });

  final String title;
  final Widget actionButton;
  final VoidCallback onActionButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 22, bottom: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(
              Iconsax.arrow_left_2,
              size: 24,
              color: AppColor.textPrimary, // Add explicit color
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.textStyle19,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: onActionButtonPressed,
              child: actionButton,
            ),
          ),
        ],
      ),
    );
  }
}
