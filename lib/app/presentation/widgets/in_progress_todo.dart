import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:daily_activity/app/data/models/task_model.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_text_styles.dart';

class InProgressTodo extends StatelessWidget {
  const InProgressTodo({super.key, required this.data});

  final TaskModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(39),
          color: data.category.color.withAlpha(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(19),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      style: AppTextStyles.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    data.category.icon,
                    color: data.category.color,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 19, right: 19, bottom: 11),
              child: Text(
                data.description,
                style: AppTextStyles.smallBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SliderTheme(
              data: SliderThemeData().copyWith(

                activeTrackColor: AppColors.primary,
                // Matches primary color (main brand color)
                inactiveTrackColor: AppColors.primary.withAlpha(76),
                // Lighter version for inactive track
                thumbColor: AppColors.primary,
                // Thumb matches primary color
                overlayColor: AppColors.primary.withAlpha(90),
                // Subtle glow effect when sliding
                trackHeight: 6.0,
                // Adjust track thickness
                thumbShape: SliderComponentShape.noThumb,
                // Remove thumb if needed
                disabledActiveTrackColor: data.category.color,),

              child: Slider(
                value: data.progress,
                onChanged: null,
              ),
            ),
          ],
        ));
  }
}
