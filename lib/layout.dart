import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
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
  int currentScreen = 0;

  final List<Widget> selectedScreen = [
    const HomeViewBody(),
    const SettingsViewBody(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Widget> curvedIcons = [
      Icon(
        Iconsax.home,
        size: 26,
        color: currentScreen == 0 ? colorScheme.surface : colorScheme.primary,
      ),
      Icon(
        Iconsax.user,
        size: 26,
        color: currentScreen == 1 ? colorScheme.surface : colorScheme.primary,
      ),
    ];
    return BackgroundLayout(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          GoRouter.of(context).push(AppRouter.kAddProject);
        },
        backgroundColor: colorScheme.primary,
        child: Icon(
          Iconsax.add,
          color: colorScheme.surface,
          size: 26,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CurvedNavigationBar(
          color: colorScheme.surface,
          height: 64,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (value) {
            setState(() {
              currentScreen = value;
              DebugLogger.log("$value");
            });
          },
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: colorScheme.primary,
          items: curvedIcons),
      children: [selectedScreen[widget.currentScreen ?? currentScreen]],
    );
  }
}
