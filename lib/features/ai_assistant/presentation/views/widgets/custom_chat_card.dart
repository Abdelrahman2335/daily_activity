import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomChatCard extends StatelessWidget {
  const CustomChatCard({
    super.key,
    required this.isUser,
    required this.text,
  });
  final bool isUser;
  final String text;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: mediaQuery.width * 0.8),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: isUser ? Radius.zero : Radius.circular(16),
            topLeft: isUser ? Radius.circular(16) : Radius.zero,
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: colorScheme.surface,
          gradient: isUser
              ? null
              : LinearGradient(
                  begin: AlignmentGeometry.topLeft,
                  end: AlignmentGeometry.bottomRight,
                  colors: [
                    AppColor.primary,
                    AppColor.accentPurple,
                  ],
                ),
        ),
        child: Text(
          text,
          style: AppTextStyles.textStyle14.copyWith(
            color: isUser
                ? colorScheme.onSurface
                : Colors.white, // or Theme.of(context).colorScheme.surface
          ),
        ),
      ),
    );
  }
}
