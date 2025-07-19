import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/home/data/data_sources/categories.dart';
import 'package:daily_activity/features/home/data/models/task_category.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
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
            value: categories[TaskCategory.values[index]]!.title,
            child: Row(
              children: [
                Icon(
                  categories[TaskCategory.values[index]]!.icon,
                  color: categories[TaskCategory.values[index]]!.color,
                ),
                const SizedBox(width: 10),
                Text(
                  categories[TaskCategory.values[index]]!.title,
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
