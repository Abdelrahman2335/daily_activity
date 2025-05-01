import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const headingLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const headingMedium = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.card,
  );

  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,

  ); static const smallBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,

  );
}
