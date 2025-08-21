import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProjectAppBar extends StatelessWidget {
  const ProjectAppBar({
    super.key,
    required this.title,
    required this.actionButton,
    required this.onActionButtonPressed,
  });

  final String title;
  final Widget actionButton;
  final VoidCallback? onActionButtonPressed;

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
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.textStyle19(context),
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
