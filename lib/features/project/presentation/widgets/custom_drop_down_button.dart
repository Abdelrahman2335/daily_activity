import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/models/project_category.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.onSave,
  });

  final dynamic onSave;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField(
      validator: (value) {
        if (value != null) {
          return null;
        }
        AutovalidateMode.always;
        return "Field is required";
      },
      icon: const Icon(Iconsax.arrow_down_1),
      borderRadius: BorderRadius.circular(19),
      menuMaxHeight: 400,
      onChanged: (value) {},
      onSaved: (value) {
        onSave.categoryChange(value!);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 19),
        fillColor: colorScheme.surface,
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
          ProjectCategoryModel? category =
              categories[ProjectCategory.values[index]] ??
                  categories[ProjectCategory.values.first];
          return DropdownMenuItem(
            value: category,
            child: Row(
              children: [
                Icon(
                  category!.icon,
                  color: Color(category.colorValue),
                ),
                const SizedBox(width: 10),
                Text(
                  category.title,
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
