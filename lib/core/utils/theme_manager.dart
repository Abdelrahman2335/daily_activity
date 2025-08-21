import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class ThemeManager {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        brightness: Brightness.light,
        primary: AppColor.primary,
        secondary: AppColor.secondary,
        surface: AppColor.card,
      ),
      scaffoldBackgroundColor: AppColor.background,
      cardColor: AppColor.card,
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        bodyLarge: GoogleFonts.lato(color: AppColor.textPrimary),
        bodyMedium: GoogleFonts.lato(color: AppColor.textSecondary),
        titleLarge: GoogleFonts.lato(color: AppColor.textPrimary),
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
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        brightness: Brightness.dark,
        primary: AppColor.primary,
        secondary: AppColor.secondary,
        surface: AppColor.darkCard,
      ),
      scaffoldBackgroundColor: AppColor.darkBackground,
      cardColor: AppColor.darkCard,
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: GoogleFonts.lato(color: AppColor.darkTextPrimary),
        bodyMedium: GoogleFonts.lato(color: AppColor.darkTextSecondary),
        titleLarge: GoogleFonts.lato(color: AppColor.darkTextPrimary),
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
