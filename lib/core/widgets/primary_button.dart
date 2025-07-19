import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.textColor,
    required this.text,
    this.isSelected = false,
  });

  final VoidCallback onPressed;
  final Color? textColor;
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
        backgroundColor: isSelected ? AppColor.primary : AppColor.card,
      ),
      child: Text(
        text,
        style: AppTextStyles.textStyle14.copyWith(
            color: isSelected ? AppColor.card : AppColor.primary,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
