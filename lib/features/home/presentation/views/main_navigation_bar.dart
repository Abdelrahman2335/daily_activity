import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({
    super.key,
  });

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int currentIndex = 0;

  final List<Widget> curvedIcons = [
    Icon(
      Iconsax.home,
      size: 26,
    ),
    Icon(
      Iconsax.calendar,
      size: 26,
    ),
    Icon(
      Iconsax.document_text1,
      size: 26,
    ),
    
    Icon(
      Iconsax.document_text1,
      size: 26,
    ),
  ];

  final List<Widget> selectedScreen = [
    const HomeViewBody(),
    const HomeViewBody(),
    const HomeViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AppBackground(children: [selectedScreen[currentIndex]]),
        bottomNavigationBar: CurvedNavigationBar(
            color: AppColor.accentGreen,
            height: 64,
            animationDuration: const Duration(milliseconds: 300),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },

            // backgroundColor: AppColor.background,s
            buttonBackgroundColor: AppColor.secondary,
            items: curvedIcons));
  }
}
