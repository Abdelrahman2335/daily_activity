import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DarkThemeToggle extends StatefulWidget {
  const DarkThemeToggle({
    super.key,
  });

  @override
  State<DarkThemeToggle> createState() => _DarkThemeToggleState();
}

class _DarkThemeToggleState extends State<DarkThemeToggle> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      leading: const Icon(
        Iconsax.brush_4,
        color: AppColor.primary,
      ),
      title: const Text(
        "Dark Theme",
      ),
      trailing: Switch(
          activeColor: AppColor.primary,
          value: isDark,
          onChanged: (value) {
            setState(() {
              isDark = !isDark;
            });
          }),
    );
  }
}
