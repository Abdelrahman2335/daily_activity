import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CustomDateTimeButton extends StatelessWidget {
  const CustomDateTimeButton({
    super.key,
    required this.title,
    this.onTap,
    this.selectedDate,
  });

  final String title;
  final DateTime? selectedDate;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      tileColor: colorScheme.surface,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Iconsax.calendar_1,
          color: colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.textStyle14.copyWith(
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        selectedDate == null
            ? "Select Date"
            : DateFormat("dd/MM/yy").format(selectedDate!),
        style: AppTextStyles.textStyle16.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Iconsax.arrow_down_1),
      onTap: onTap,
    );
  }
}
