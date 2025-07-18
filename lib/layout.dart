import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
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
  int currentIndex = 0;

  final List<Widget> curvedIcons = [
    Icon(
      Iconsax.home,
      size: 26,
    ),
    Icon(
      Iconsax.calendar_14,
      size: 26,
    ),
    Icon(
      Iconsax.shopping_bag,
      size: 26,
    ),
  ];

  final List<Widget> selectedScreen = [
    const HomeView(),
    const HomeView(),
    const HomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: selectedScreen[currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
            height: 64,
            animationDuration: const Duration(milliseconds: 300),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            backgroundColor: AppColor.background,
            buttonBackgroundColor: AppColor.primary,
            items: curvedIcons));
  }
}
