import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:daily_activity/app/presentation/widgets/app_background.dart';
import 'package:daily_activity/app/presentation/widgets/in_progress_todo.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello!",
              style: AppTextStyles.small,
            ),
            Text(
              "Abdelrahman",
              style: AppTextStyles.smallBold,
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 19),
          child: CircleAvatar(
            child: Icon(
              PhosphorIcons.user(),
              color: AppColors.accentPink,
            ),
          ),
        ),
        actions: [
          InkWell(
              onTap: () {},
              child: Icon(
                PhosphorIcons.bellSimple(PhosphorIconsStyle.fill),
                size: 26,
              ))
        ],
        actionsPadding: EdgeInsets.only(right: 24, top: 8),
      ),
      body: AppBackground(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 26),
                sliver: SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  stretch: true,
                  clipBehavior: Clip.antiAlias,
                  automaticallyImplyLeading: false,

                  // clipBehavior: Clip.hardEdge,

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
                            style: AppTextStyles.body,
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
                              style: AppTextStyles.bodyBold,
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
                                PhosphorIcons.dotsThreeOutline(
                                    PhosphorIconsStyle.fill),
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
                                style: AppTextStyles.body,
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
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 14,
                  ),
                  child: Text(
                    "In Progress",
                    style: AppTextStyles.headingMedium,
                  ),
                ),
              ),
              SliverGrid(
                delegate: (SliverChildBuilderDelegate(
                    (context, index) => InProgressTodo(),
                    childCount: 2)), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
