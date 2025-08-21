import 'package:daily_activity/core/models/data_time_model.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor = colorScheme.surface;
    Color textColor = colorScheme.onSurface; 

    if (isSelected) {
      backgroundColor = colorScheme.primary; 
      textColor =
          colorScheme.onPrimary;
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
            Text(dataTimeModel.monthName,
                style: AppTextStyles.textStyle14.copyWith(color: textColor)),
            Text("${dataTimeModel.day}",
                style: AppTextStyles.textStyle19(context)
                    .copyWith(color: textColor, fontWeight: FontWeight.bold)),
            Text(dataTimeModel.weekDayName,
                style: AppTextStyles.textStyle14.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
