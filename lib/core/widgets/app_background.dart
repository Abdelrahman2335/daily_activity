import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../../features/home/presentation/widgets/blurred_circle.dart';

class AppBackground extends StatelessWidget {
  const AppBackground(
      {super.key, required this.children, this.addPadding = true});

  final List<Widget> children;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: addPadding == true
            ? const EdgeInsets.symmetric(horizontal: 19)
            : EdgeInsets.zero,
        child: Stack(
          children: [
            // Top blur circle
            Positioned(
              top: 70,
              right: 60,
              child: BlurredCircle(
                color: AppColor.secondary.withAlpha(46),
                size: 24,
              ),
            ),

            // Bottom blur circle
            Positioned(
              top: 226,
              left: 19,
              child: BlurredCircle(
                color: AppColor.accentGreen.withAlpha(39),
                size: 19,
              ),
            ),
            Positioned(
              top: 500,
              left: 150,
              child: BlurredCircle(
                color: AppColor.primary.withAlpha(36),
                size: 19,
              ),
            ),
            Positioned(
              top: 300,
              right: 40,
              child: BlurredCircle(
                color: AppColor.primary.withAlpha(30),
                size: 19,
              ),
            ),

            for (Widget i in children) i
          ],
        ),
      ),
    );
  }
}
