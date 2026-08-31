import 'package:flowi/core/widgets/app_background.dart';
import 'package:flowi/features/home/presentation/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      addPadding: false,
      children: [
        const HomeViewBody(),
      ],
    );
  }
}
