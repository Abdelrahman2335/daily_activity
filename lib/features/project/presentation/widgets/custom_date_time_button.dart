import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomDateTimeButton extends StatelessWidget {
  const CustomDateTimeButton({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      tileColor: Colors.white,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.primary.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Iconsax.calendar_1,
          color: AppColor.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.textStyle14.copyWith(
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        "01 May, 2022",
        style: AppTextStyles.textStyle16.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Iconsax.arrow_down_1),
      onTap: onTap,
    );
  }
}
