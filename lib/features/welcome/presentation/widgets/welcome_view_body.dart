import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/utils/assets.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class WelcomeViewBody extends StatelessWidget {
  const WelcomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 29),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.welcomePhoto,
          ),
          Text("Task Management &\n To-Do List",
              textAlign: TextAlign.center, style: AppTextStyles.textStyle26),
          SizedBox(
            height: 24,
          ),
          Text(
            Constants.appDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyle12,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
          ),
          SecondaryButton(
            height: 60,
            onPressed: () {
              GoRouter.of(context).go(AppRouter.kLayOut);
            },
            buttonLabel: Text(
              "Let's Start",
              style: AppTextStyles.textStyle19.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white, // White text color
              ),
            ),
            icon: Iconsax.arrow_right_3,
            addIcon: true,
          ),
        ],
      ),
    );
  }
}
