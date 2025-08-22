import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/project_model.dart';
import '../../../../core/utils/app_text_styles.dart';

class InProgressTodo extends StatelessWidget {
  const InProgressTodo({super.key, required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kEditProject, extra: project);
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(39),
            color: Color(project.category.colorValue).withAlpha(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(19),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: AppTextStyles.textStyle12(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      project.category.icon,
                      color: Color(project.category.colorValue),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19, right: 19, bottom: 11),
                child: Text(
                  project.description,
                  style: AppTextStyles.textStyleBold12(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SliderTheme(
                data: SliderThemeData().copyWith(
                  activeTrackColor: AppColor.primary,
                  // Matches primary color (main brand color)
                  inactiveTrackColor: AppColor.primary.withAlpha(76),
                  // Lighter version for inactive track
                  thumbColor: AppColor.primary,
                  // Thumb matches primary color
                  overlayColor: AppColor.primary.withAlpha(90),
                  // Subtle glow effect when sliding
                  trackHeight: 6.0,
                  // Adjust track thickness
                  thumbShape: SliderComponentShape.noThumb,
                  // Remove thumb if needed
                  disabledActiveTrackColor: Color(project.category.colorValue),
                ),
                child: Slider(
                  value: project.progress,
                  onChanged: null,
                ),
              ),
            ],
          )),
    );
  }
}
