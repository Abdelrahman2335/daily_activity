import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/welcome/presentation/widgets/welcome_view_body.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      addPadding: true,
      children: [
        const WelcomeViewBody(),
      ],
    );
  }
}
