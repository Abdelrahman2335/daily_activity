import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/blurred_circle.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right:  24,left: 24,top: 49),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Top blur circle
                Positioned(
                  top: 70,
                  right: 60,
                  child: BlurredCircle(
                    color: AppColors.secondary.withAlpha(50),
                    size: 24,
                  ),
                ),

                // Bottom blur circle
                Positioned(
                  bottom: 90,
                  left: 54,
                  child: BlurredCircle(
                    color: AppColors.backgroundEffect.withAlpha(50),
                    size: 19,
                  ),
                ),

                Positioned(child: Image.asset("assets/welcome photo.png")),
              ],
            ),
            Text("Task Management & To-Do List",
                style: AppTextStyles.headingLarge),
            SizedBox(height: 14),
            Text(
              "This productive tool is designed to help you better manage your task project-wise conveniently!",
              style: AppTextStyles.small,
            ),
            SizedBox(height: 34),
            SizedBox(
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
                  onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
