import 'package:daily_activity/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class DarkThemeToggle extends StatelessWidget {
  const DarkThemeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isDarkMode = context.watch<SettingCubit>().isDark;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return SwitchListTile(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
          ),
          secondary: Icon(
            Iconsax.brush_4,
            color: colorScheme.primary,
          ),
          title: const Text(
            "Dark Theme",
          ),
          value: isDarkMode,
          onChanged: (bool value) {
            context.read<SettingCubit>().toggleTheme();
          },
          activeThumbColor: colorScheme.primary,
        );
      },
    );
  }
}
