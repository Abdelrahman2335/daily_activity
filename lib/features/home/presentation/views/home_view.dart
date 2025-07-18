import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      addPadding: false,
      children: [
        const HomeViewBody(),
      ],
    );
  }
}
