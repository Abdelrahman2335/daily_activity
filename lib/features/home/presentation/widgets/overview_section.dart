import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// This is the to part of the Home Screen that shows the overview of today's tasks
// It includes a progress indicator and a button to view tasks.
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 19),
      sliver: SliverAppBar(
        backgroundColor: Colors.transparent,
        stretch: true,
        clipBehavior: Clip.antiAlias,
        automaticallyImplyLeading: false,
        expandedHeight: MediaQuery.of(context).size.height * 0.24,
        flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(39),
            top: Radius.circular(39),
          ),
          child: Container(
            color: AppColors.primary,
            child: Stack(children: [
              Positioned(
                top: 26,
                left: 19,
                child: Text(
                  "Your today's task\nalmost done!",
                  style: AppTextStyles.textStyle14,
                ),
              ),
              Positioned(
                bottom: 36,
                left: 19,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: AppColors.background),
                  child: Text(
                    "View Task",
                    style: AppTextStyles.textStyle14.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                  top: 19,
                  right: 21,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: AppColors.card.withAlpha(70),
                    ),
                    width: 29,
                    height: 29,
                    child: Icon(
                      PhosphorIcons.dotsThreeOutline(PhosphorIconsStyle.fill),
                      color: AppColors.card,
                    ),
                  )),
              Positioned(
                  top: 49,
                  right: 76,
                  child: CircularPercentIndicator(
                    startAngle: 70,
                    radius: 46.0,
                    lineWidth: 9.0,
                    percent: 0.85,
                    center: const Text(
                      "85%",
                      style: AppTextStyles.textStyle14,
                    ),
                    progressColor: AppColors.card,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1700,
                  )),
            ]),
          ),
        )),
      ),
    );
  }
}
