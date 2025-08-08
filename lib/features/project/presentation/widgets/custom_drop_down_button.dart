import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/home/data/data_sources/categories.dart';
import 'package:daily_activity/features/project/presentation/manager/add_project/add_project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/models/project_category.dart';

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
      onChanged: (value) {
        context.read<AddProjectCubit>().categoryChange(value!);
      },
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
            value: categories[ProjectCategory.values[index]]!,
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
