import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/add_task/presentation/widgets/add_task.dart';
import 'package:daily_activity/features/add_task/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/features/home/presentation/widgets/task_app_bar.dart';
import 'package:flutter/material.dart';

class AddProjectViewBody extends StatefulWidget {
  const AddProjectViewBody({super.key});

  @override
  State<AddProjectViewBody> createState() => _AddProjectViewBodyState();
}

class _AddProjectViewBodyState extends State<AddProjectViewBody> {
 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
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
                onActionButtonPressed: () {},
              ),
              const CustomDropDownButton(),
              const SizedBox(height: 30),
              CustomTextFormField(
                onChanged: () {},
                maxLines: 1,
                maxLength: 50,
                hintText: 'Task Name',
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                onChanged: () {},
                minLines: 5,
                maxLines: 6,
                hintText: 'Description',
              ),
              const SizedBox(height: 30),
              const AddTask(),
              const SizedBox(height: 20),
              SecondaryButton(
                onPressed: () {},
                buttonLabel: Text("Add Task",
                    style: AppTextStyles.textStyle14.copyWith(
                      color: AppColor.accentOrange,
                    )),
                backgroundColor: AppColor.card,
                textColor: AppColor.accentOrange,
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
