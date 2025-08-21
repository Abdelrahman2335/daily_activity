import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/models/project_model.dart';

class CustomTodayTaskCard extends StatelessWidget {
  const CustomTodayTaskCard({
    super.key,
    required this.taskModel,
    required this.index,
  });

  final List<ProjectModel> taskModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                taskModel[index].category.title,
                style: AppTextStyles.textStyle12(context),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor:
                    Color(taskModel[index].category.colorValue).withAlpha(37),
                child: Icon(
                  taskModel[index].category.icon,
                  size: 24,
                  color: Color(taskModel[index].category.colorValue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            taskModel[index].title,
            style: AppTextStyles.textStyleBold12(context),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Iconsax.clock,
                size: 16,
                color: AppColor.accentLightPurple,
              ),
              const SizedBox(width: 8),
              Text(
                "10:00 AM",
                style: AppTextStyles.textStyle12(context).copyWith(
                  color: AppColor.accentLightPurple,
                ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: taskModel[index].status.color.withAlpha(20),
                ),
                onPressed: null,
                child: Text(
                  taskModel[index].status.displayName,
                  style: AppTextStyles.textStyle12(context).copyWith(
                    color: taskModel[index].status.color,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
