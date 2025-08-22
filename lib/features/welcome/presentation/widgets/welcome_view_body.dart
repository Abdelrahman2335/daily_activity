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
    final mediaQuery = MediaQuery.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 29),
          child: Column(
            children: [
              Image.asset(
                Assets.welcomePhoto,
                width: mediaQuery.size.width * 0.8,
                height: mediaQuery.size.height * 0.4,
                fit: BoxFit.contain,
                cacheWidth:
                    (mediaQuery.size.width * 0.8 * mediaQuery.devicePixelRatio)
                        .round(),
              ),
              Text("Task Management &\n To-Do List",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textStyle26(context)),
              SizedBox(
                height: 24,
              ),
              Text(
                Constants.appDescription,
                textAlign: TextAlign.center,
                style: AppTextStyles.textStyle12(context),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.09,
              ),
              SecondaryButton(
                height: 60,
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.kLayOut);
                },
                buttonLabel: Text(
                  "Let's Start",
                  style: AppTextStyles.textStyle19(context).copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // White text color
                  ),
                ),
                icon: Iconsax.arrow_right_3,
                addIcon: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
