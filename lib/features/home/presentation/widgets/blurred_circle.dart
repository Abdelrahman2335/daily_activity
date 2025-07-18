import 'package:flutter/material.dart';

class BlurredCircle extends StatelessWidget {
  final Color color;
  final double size;

  const BlurredCircle({
    required this.color,
    required this.size,
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(

            color: color,
            blurRadius: 55,
            spreadRadius: 60,
          ),
        ],
        // color: color,
      ),
      width: size,
      height: size,
    );
  }
}
