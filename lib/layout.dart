import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/add_task/presentation/views/add_project_view.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final List<Widget> selectedScreen = [
    const HomeViewBody(),
    const HomeViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> curvedIcons = [
      Icon(
        Iconsax.home,
        size: 26,
        color: currentScreen == 0 ? Colors.white : AppColor.primary,
      ),
      Icon(
        Iconsax.profile_2user,
        size: 26,
        color: currentScreen == 1 ? Colors.white : AppColor.primary,
      ),
    ];
    return BackgroundLayout(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          GoRouter.of(context).push(AppRouter.kAddProject);
        },
        backgroundColor: AppColor.primary,
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 26,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
