import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:daily_activity/app/presentation/widgets/app_background.dart';
import 'package:daily_activity/app/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../data/data_sources/dummy_data.dart';
import '../widgets/in_progress_todo.dart';

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
                Iconsax.notification,
                size: 26,
              ))
        ],
        actionsPadding: EdgeInsets.only(right: 24, top: 8),
      ),
      body: AppBackground(
        addPadding: false,
        children: [
          CustomScrollView(

            slivers: [

              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 26, horizontal: 19),
                sliver: SliverAppBar(
                  backgroundColor: Colors.transparent,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 19,
                    bottom: 11,
                  ),
                  child: Text(
                    "In Progress",
                    style: AppTextStyles.headingMedium,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.21,
                  width: double.infinity,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 9,
                          childAspectRatio: 0.8),
                      itemCount: dummyTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InProgressTodo(
                          data: dummyTasks[index],
                        );
                      }),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, bottom: 11, top: 11),
                  child: Text(
                    "Tasks",
                    style: AppTextStyles.headingMedium,
                  ),
                ),
              ),
              SliverList(

                delegate: SliverChildBuilderDelegate(

                  childCount: dummyTasks.length,

                  (ctx, index) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19,vertical: 8),
                      child: TaskCard(
                        data: dummyTasks[index],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
