import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/settings/presentation/widgets/settings_view_body.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(children: [
      const SettingsViewBody(),
    ]);
  }
}
