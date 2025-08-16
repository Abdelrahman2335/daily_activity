import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/primary_button.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// This is the top part of the Home Screen that shows the overview of today's tasks
// It includes a progress indicator and a button to view tasks.
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double percent =
        double.tryParse(context.read<HomeCubit>().overallProgress) ?? 0;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 19),
      sliver: SliverAppBar(
        backgroundColor: Colors.transparent,
        stretch: true,
        clipBehavior: Clip.antiAlias,
        automaticallyImplyLeading: false,
        expandedHeight: 180,
        flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(39),
            top: Radius.circular(39),
          ),
          child: Container(
            color: AppColor.primary,
            child: Stack(children: [
              Positioned(
                top: 26,
                left: 19,
                child: Text(
                  "Overall progress \nKeep it up!",
                  style:
                      AppTextStyles.textStyle14.copyWith(color: AppColor.card),
                ),
              ),
              Positioned(
                bottom: 36,
                left: 19,
                child: PrimaryButton(
                    text: "View Project",
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kTodayTasks);
                    }),
              ),
              Positioned(
                  top: 59,
                  right: 66,
                  child: CircularPercentIndicator(
                    startAngle: 70,
                    radius: 54.0,
                    lineWidth: 9.0,
                    percent: percent / 100,
                    center: Text(
                      "$percent%",
                      style: AppTextStyles.textStyle14
                          .copyWith(color: AppColor.card),
                    ),
                    progressColor: AppColor.card,
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
