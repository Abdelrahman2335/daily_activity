import 'package:daily_activity/features/settings/presentation/theme_cubit/theme_cubit.dart';
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

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
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
          value: isDark,
          onChanged: (bool value) {
            context.read<ThemeCubit>().toggleTheme();
          },
          activeThumbColor: colorScheme.primary,
 
        );
      },
    );
  }
}
