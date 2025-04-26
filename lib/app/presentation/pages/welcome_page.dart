import 'package:daily_activity/app/core/constants/app_colors.dart';
import 'package:daily_activity/app/core/constants/app_text_styles.dart';
import 'package:daily_activity/app/presentation/pages/home_page.dart';
import 'package:daily_activity/app/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(children: [
        Padding(
          padding: const EdgeInsets.only( top: 29),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/welcome photo.png",
              ),
              Text("Task Management &\n To-Do List",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingLarge),
              SizedBox(
                height: 24,
              ),
              Text(
                "This productive tool is designed to help you better manage your task project-wise conveniently!",
                textAlign: TextAlign.center,
                style: AppTextStyles.small,
              ),
              const SizedBox(
                height: 64,
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Purple background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19), // pill shape
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => HomePage()));
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
                                PhosphorIcons.arrowRight(
                                    PhosphorIconsStyle.fill),
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
      ]),
    );
  }
}
