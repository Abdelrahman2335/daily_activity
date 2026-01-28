import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/utils/constants.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
        addPadding: true,
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(
              Iconsax.arrow_left_2,
              size: 24,
            ),
          ),
          title: Text(
            "Terms & Conditions",
            style: AppTextStyles.textStyle16,
          ),
          centerTitle: true,
        ),
        children: [
          SingleChildScrollView(
              child: Text(
            Constants.terms,
            style: AppTextStyles.textStyle12(context),
          ))
        ]);
  }
}
