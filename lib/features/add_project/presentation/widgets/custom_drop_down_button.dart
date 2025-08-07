import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/home/data/data_sources/categories.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/models/project_category.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    this.validator,
  });

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: validator,
      icon: const Icon(Iconsax.arrow_down_1),
      borderRadius: BorderRadius.circular(19),
      menuMaxHeight: 400,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 19),
        fillColor: Colors.white,
        filled: true,

        hintText: 'Task Group',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none, // No visible border
        ),
        // Removes the border
      ),
      items: [
        ...List.generate(categories.length, (index) {
          return DropdownMenuItem(
            value: categories[ProjectCategory.values[index]]!.title,
            child: Row(
              children: [
                Icon(
                  categories[ProjectCategory.values[index]]!.icon,
                  color: categories[ProjectCategory.values[index]]!.color,
                ),
                const SizedBox(width: 10),
                Text(
                  categories[ProjectCategory.values[index]]!.title,
                  style: AppTextStyles.textStyle14,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
