import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.buttonLabel,
    this.icon,
    this.addIcon = false,
    this.height = 54,
    this.width = double.infinity,
    this.backgroundColor = AppColor.primary,
    this.textColor = Colors.white,
  });
  final VoidCallback onPressed;
  final Widget buttonLabel;
  final IconData? icon;
  final bool addIcon;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: buttonLabel,
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
