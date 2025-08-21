import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isSelected = false,
  });

  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final String text;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: AppTextStyles.textStyle14
            .copyWith(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
