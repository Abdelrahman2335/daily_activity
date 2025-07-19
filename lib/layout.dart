import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_view_body.dart';
import 'package:daily_activity/features/home/presentation/widgets/today_task_view_body.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LayOut extends StatefulWidget {
  const LayOut({
    super.key,
  });
  @override
  State<LayOut> createState() => _LayOutState();
}

class _LayOutState extends State<LayOut> {
  

  int currentScreen = 0;


  final List<Widget> curvedIcons = [
    Icon(
      Iconsax.home,
      size: 26,
    ),
    Icon(
      Iconsax.calendar_1,
      size: 26,
    ),
    Icon(
      Iconsax.add_square,
      size: 26,
    ),
    Icon(
      Iconsax.document_text_14,
      size: 26,
    ),
    Icon(
      Iconsax.profile_2user,
      size: 26,
    ),
  ];

  final List<Widget> selectedScreen = [
    const HomeViewBody(),
    const TodayTaskViewBody(),
    const HomeViewBody(),
    const HomeViewBody(),
    const HomeViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      bottomNavigationBar: CurvedNavigationBar(
          height: 64,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (value) {
            setState(() {
              currentScreen = value;
            });
          },
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColor.primary,
          items: curvedIcons),
      children: [selectedScreen[currentScreen]],
    );
  }
}
