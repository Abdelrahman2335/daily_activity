import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:daily_activity/app/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
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
              SliverAppBar(
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
                    bottom: Radius.circular(31),
                    top: Radius.circular(31),
                  ),
                  child: Container(
                    color: AppColors.primary,
                    child: Stack(children: [
                      Positioned(
                        top: 26,
                        left: 26,
                        child: Text(
                          "Your today's task\nalmost done!",
                          style: AppTextStyles.body,
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 26,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background),
                          child: Text("View Task"),
                        ),
                      ),
                      Positioned(
                          top: 26,
                          right: 24,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: AppColors.card.withAlpha(70),

                            ),
                            width: 36,
                            height: 36,
                            child: Icon(PhosphorIcons.dotsThreeOutline(
                                PhosphorIconsStyle.fill),color: AppColors.card,),
                          ))
                    ]),
                  ),
                )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
