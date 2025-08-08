import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_view_body.dart';
import 'package:daily_activity/features/settings/presentation/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class LayOut extends StatefulWidget {
  const LayOut({
    super.key,
    this.currentScreen,
  });
  @override
  State<LayOut> createState() => _LayOutState();

  final int? currentScreen;
}

class _LayOutState extends State<LayOut> {
  int currentScreen({int screen = 0}) {
    int currentScreen = widget.currentScreen ?? screen;

    return currentScreen;
  }

  final List<Widget> selectedScreen = [
    const HomeViewBody(),
    const SettingsViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> curvedIcons = [
      Icon(
        Iconsax.home,
        size: 26,
        color: currentScreen() == 0 ? Colors.white : AppColor.primary,
      ),
      Icon(
        Iconsax.user,
        size: 26,
        color: currentScreen() == 1 ? Colors.white : AppColor.primary,
      ),
    ];
    return BackgroundLayout(
      resizeToAvoidBottomInset: false,
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
              currentScreen(screen: value);
            });
          },
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColor.primary,
          items: curvedIcons),
      children: [selectedScreen[currentScreen()]],
    );
  }
}
