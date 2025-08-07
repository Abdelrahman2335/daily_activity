import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/features/add_project/presentation/widgets/add_task.dart';
import 'package:daily_activity/features/add_project/presentation/widgets/custom_date_time_button.dart';
import 'package:daily_activity/features/add_project/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/core/widgets/task_app_bar.dart';
import 'package:flutter/material.dart';

class AddProjectViewBody extends StatefulWidget {
  const AddProjectViewBody({super.key});

  @override
  State<AddProjectViewBody> createState() => _AddProjectViewBodyState();
}

class _AddProjectViewBodyState extends State<AddProjectViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? taskTitle, description;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              TaskAppBar(
                title: "Add Project",
                actionButton: Text(
                  "Done",
                  style: AppTextStyles.textStyle16.copyWith(
                    color: AppColor.primary,
                  ),
                ),
                onActionButtonPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              ),
             CustomDropDownButton(
                validator: (value) {
                  if (value == null) {
                    return "Field is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                onSaved: (value) {
                  taskTitle = value;
                },
                maxLines: 1,
                maxLength: 50,
                hintText: 'Task Name',
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                onSaved: (value) {
                  description = value;
                },
                minLines: 5,
                maxLines: 6,
                hintText: 'Description',
              ),
              const SizedBox(height: 30),
              const AddTask(),
            
              const SizedBox(height: 30),
              CustomDateTimeButton(
                title: "Start Date",
              ),
              const SizedBox(height: 30),
              CustomDateTimeButton(
                title: "End Date",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
