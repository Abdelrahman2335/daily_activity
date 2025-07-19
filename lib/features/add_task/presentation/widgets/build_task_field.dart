 import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

CustomTextFormField buildTaskField() {
    return CustomTextFormField(
      icon: Icon(FontAwesomeIcons.gripVertical),
      onChanged: () {},
      maxLines: 1,
      hintText: 'Task Name',
      suffixIcon: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
       
        },
      ),
    );
  }