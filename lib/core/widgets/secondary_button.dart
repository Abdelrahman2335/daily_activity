import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.addIcon = false,
    this.height = 54,
  });
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool addIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary, // Purple background
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
