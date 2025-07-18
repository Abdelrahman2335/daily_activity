
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.addIcon = false,
  });
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool addIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              if (addIcon)
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
            ],
          )),
    );
  }
}