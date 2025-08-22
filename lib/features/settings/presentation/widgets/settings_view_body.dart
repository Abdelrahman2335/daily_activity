import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/features/settings/presentation/widgets/dark_theme_toggle.dart';
import 'package:daily_activity/features/settings/presentation/widgets/name_editor.dart';
import 'package:flutter/material.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          const SizedBox(
            height: 47,
          ),
          const NameEditor(),
          const SizedBox(
            height: 27,
          ),
          const DarkThemeToggle(),
          const SizedBox(
            height: 27,
          ),
          const Spacer(),
          Text(
            Constants.appVersion,
            style: AppTextStyles.textStyle12(context),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
