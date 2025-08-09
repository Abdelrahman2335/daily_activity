import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/models/project_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.data});

  final ProjectModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        color: AppColor.card,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 19,
            bottom: 19,
            left: 14,
            child: CircleAvatar(
              backgroundColor: Color(data.category.colorValue).withAlpha(37),
              child: Icon(
                data.category.icon,
                color: Color(data.category.colorValue),
                size: 24,
              ),
            ),
          ),
          Positioned(
            top: 26,
            left: 64,
            child: Text(
              data.category.title,
              style: AppTextStyles.textStyleBold12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 64,
            child: Text(
              data.title,
              style: AppTextStyles.textStyle12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            top: 19,
            bottom: 19,
            right: 19,
            child: CircularPercentIndicator(
              startAngle: 70,
              radius: 26,
              lineWidth: 3,
              percent: data.progress.toDouble() / 100,
              progressColor: Color(data.category.colorValue),
              center: Text(
                "${data.progress}%",
                style: AppTextStyles.textStyleBold12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
