import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/widgets/secondary_button.dart';
import 'package:daily_activity/features/add_task/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/features/home/presentation/widgets/task_app_bar.dart';
import 'package:flutter/material.dart';

class AddProjectViewBody extends StatefulWidget {
  const AddProjectViewBody({super.key});

  @override
  State<AddProjectViewBody> createState() => _AddProjectViewBodyState();
}

class _AddProjectViewBodyState extends State<AddProjectViewBody> {
  late TextEditingController taskNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    taskNameController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    taskNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CustomTextFormField> taskList = [];
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            const TaskAppBar(
              title: "Add Project",
            ),
            const CustomDropDownButton(),
            const SizedBox(height: 30),
            CustomTextFormField(
              onChanged: () {},
              maxLines: 1,
              maxLength: 50,
              hintText: 'Task Name',
              controller: taskNameController,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              onChanged: () {},
              minLines: 5,
              maxLines: 6,
              hintText: 'Description',
              controller: descriptionController,
            ),
            const SizedBox(height: 30),
           
            const SizedBox(height: 30),
            SecondaryButton(
              onPressed: () {},
              text: "Add Task",
              backgroundColor: AppColor.card,
              textColor: AppColor.primary,
              width: MediaQuery.of(context).size.width - 40,
            ),
          ],
        ),
      ),
    );
  }
}
