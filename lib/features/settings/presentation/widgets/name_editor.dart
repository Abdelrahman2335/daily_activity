import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NameEditor extends StatelessWidget {
  const NameEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: null,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Iconsax.user,
          color: AppColor.accentTeal,
        ),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
    );
  }
}
