import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme
                        .error, // Using error color instead of accentPink
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello!",
                    style: AppTextStyles.textStyle12(context),
                  ),
                  Text(
                    "Abdelrahman",
                    style: AppTextStyles.textStyleBold12(context),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  // Add notification action here
                },
                icon: Icon(
                  Iconsax.notification,
                  size: 24,
                  color: colorScheme.onSurface, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
