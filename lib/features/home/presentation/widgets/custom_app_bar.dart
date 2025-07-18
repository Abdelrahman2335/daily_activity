import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 22, left: 19, right: 12, bottom: 11),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 12),
                child: CircleAvatar(
                  child: Icon(
                    PhosphorIcons.user(),
                    color: AppColor.accentPink,
                  ),
                ),
              ),
              const Column(
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 14,
                ),
                child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Iconsax.notification,
                      size: 26,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
