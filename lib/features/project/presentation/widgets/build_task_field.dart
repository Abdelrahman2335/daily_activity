import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildTaskField extends StatefulWidget {
  const BuildTaskField({super.key, required this.onPressed, this.onSaved});
  final VoidCallback onPressed;
  final void Function(String?)? onSaved;
  @override
  State<BuildTaskField> createState() => _BuildTaskFieldState();
}

class _BuildTaskFieldState extends State<BuildTaskField> {
  bool _enableField = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      key: ValueKey(widget.hashCode),
      enableField: _enableField,
      onSaved: widget.onSaved,
      onSecondPress: () {
        setState(() {
          _enableField = !_enableField;
        });
      },
      icon: IconButton(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onLongPress: () {
            setState(() {
              _enableField = !_enableField;
            });
          },
          onPressed: () {},
          icon: Icon(FontAwesomeIcons.gripVertical)),
      maxLines: 1,
      hintText: 'Task Name',
      suffixIcon: IconButton(
        icon: Icon(Icons.close),
        onPressed: widget.onPressed,
      ),
    );
  }
}
