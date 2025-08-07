import 'package:daily_activity/core/models/data_time_model.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';


class CustomCalenderCard extends StatelessWidget {
  const CustomCalenderCard({
    super.key,
    required this.dataTimeModel,
    required this.isSelected,
    required this.onTap,
  });
  final DataTimeModel dataTimeModel;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColor.card;
    Color textColor = AppColor.textPrimary;
    if (isSelected) {
      backgroundColor = AppColor.primary;
      textColor = AppColor.card;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 8,
          children: [
            Text(dataTimeModel.month,
                style: AppTextStyles.textStyle14.copyWith(color: textColor)),
            Text(dataTimeModel.day,
                style: AppTextStyles.textStyle19
                    .copyWith(color: textColor, fontWeight: FontWeight.bold)),
            Text(dataTimeModel.weekday,
                style: AppTextStyles.textStyle14.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
