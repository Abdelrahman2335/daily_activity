import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';

class TermsButton extends StatelessWidget {
  const TermsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme.onSurface;

    return OutlinedButton(
      onPressed: () {
        GoRouter.of(context).push(AppRouter.kTerms);
      },
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16),
          side: BorderSide(color: theme),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          )),
      child: Row(
        spacing: 14,
        children: [
          const Icon(
            Iconsax.document,
            color: AppColor.accentOrange,
            size: 23,
          ),
          Text(
            "Terms & Conditions",
            style: TextStyle(color: theme),
          )
        ],
      ),
    );
  }
}
