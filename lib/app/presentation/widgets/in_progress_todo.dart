import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InProgressTodo extends StatelessWidget {
  const InProgressTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      child: ListTile(
        trailing:  Icon(
          PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
      )),
    );
  }
}
