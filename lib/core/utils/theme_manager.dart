import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeManager {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        brightness: Brightness.light,
        primary: AppColor.primary,
        secondary: AppColor.secondary,
        surface: AppColor.card,
      ),
      scaffoldBackgroundColor: AppColor.background,
      cardColor: AppColor.card,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColor.textPrimary),
        bodyMedium: TextStyle(color: AppColor.textSecondary),
        titleLarge: TextStyle(color: AppColor.textPrimary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.background,
        foregroundColor: AppColor.textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        brightness: Brightness.dark,
        primary: AppColor.primary,
        secondary: AppColor.secondary,
        surface: AppColor.darkCard,
      ),
      scaffoldBackgroundColor: AppColor.darkBackground,
      cardColor: AppColor.darkCard,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColor.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColor.darkTextSecondary),
        titleLarge: TextStyle(color: AppColor.darkTextPrimary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.darkBackground,
        foregroundColor: AppColor.darkTextPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Check system brightness
  static bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
