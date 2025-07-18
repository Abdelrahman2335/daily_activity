import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

PreferredSizeWidget customAppBar() {
  return AppBar(
    title: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello!",
          style: AppTextStyles.textStyle12,
        ),
        Text(
          "Abdelrahman",
          style: AppTextStyles.smallBold,
        ),
      ],
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 19),
      child: CircleAvatar(
        child: Icon(
          PhosphorIcons.user(),
          color: AppColor.accentPink,
        ),
      ),
    ),
    actions: [
      InkWell(
          onTap: () {},
          child: Icon(
            Iconsax.notification,
            size: 26,
          ))
    ],
    actionsPadding: EdgeInsets.only(right: 24, top: 8),
  );
}
