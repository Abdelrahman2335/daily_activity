import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.onChanged,
    required this.hintText,
    required this.maxLines,
    this.maxLength,
    this.minLines,
    this.backgroundColor,
    this.icon,
    this.suffixIcon,
    this.enableField,
  });

  final VoidCallback onChanged;
  final Widget? icon;
  final bool? enableField;
  final Widget? suffixIcon;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final String hintText;
  final TextEditingController? controller;
  final Color? backgroundColor;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;
  bool _isInternalController = false;
  @override
  void initState() {
    if (widget.controller == null) {
      _controller = TextEditingController();
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enableField,
      controller: _controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        icon: widget.icon,
        counterText: "", // Hides the character counter
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: widget.backgroundColor ?? Colors.white,
        filled: true,
        hintText: widget.hintText,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
