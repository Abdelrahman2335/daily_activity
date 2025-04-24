import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:daily_activity/app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/blurred_circle.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Stack(
        children: [
          // Top blur circle
          Positioned(
            top: 70,
            right: 60,
            child: BlurredCircle(
              color: AppColors.secondary.withAlpha(46),
              size: 24,
            ),
          ),

          // Bottom blur circle
          Positioned(
            top: 240,
            left: 30,
            child: BlurredCircle(
              color: AppColors.backgroundEffect.withAlpha(46),
              size: 19,
            ),
          ),Positioned(
            top: 500,
            left: 150,
            child: BlurredCircle(
              color: AppColors.primary.withAlpha(36),
              size: 19,
            ),
          ),Positioned(
            top: 300,
            right: 40,
            child: BlurredCircle(
              color: AppColors.primary.withAlpha(30),
              size: 19,
            ),
          ),

          Positioned(
            top: 170,
            right: 50,
            left: 50,
            child: Image.asset(
              "assets/welcome photo.png",
            ),
          ),
          Positioned(
            right: 24,
            left: 24,
            top: 500,
            child: Text("Task Management & To-Do List",
                textAlign: TextAlign.center, style: AppTextStyles.headingLarge),
          ),

          Positioned(
            right: 24,
            left: 24,
            bottom: 160,
            child: Text(
              "This productive tool is designed to help you better manage your task project-wise conveniently!",
              textAlign: TextAlign.center,
              style: AppTextStyles.small,
            ),
          ),
          Positioned(
            bottom: 63,
            left: 24,
            right: 24,
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Purple background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19), // pill shape
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> HomePage()));
                  },
                  child: Center(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Text(
                            "Let's Start",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Positioned(
                          right: 9,
                          child: Center(
                            child: Icon(
                              PhosphorIcons.arrowRight(PhosphorIconsStyle.fill),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    ));
  }
}
