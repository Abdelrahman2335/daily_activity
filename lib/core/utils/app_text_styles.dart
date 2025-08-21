import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle textStyle26(BuildContext context) => TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle textStyle19(BuildContext context) => TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle textStyle12(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle textStyleBold12(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
