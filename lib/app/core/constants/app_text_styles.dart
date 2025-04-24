import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const headingLarge = TextStyle(
    fontSize: 29,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
