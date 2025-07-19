import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    required this.maxLines,
    this.maxLength,
    this.minLines,
    this.backgroundColor,
  });

  final VoidCallback onChanged;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final String hintText;
  final TextEditingController controller;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "", // Hides the character counter
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: backgroundColor ?? Colors.white,
        filled: true,
        hintText: hintText,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
