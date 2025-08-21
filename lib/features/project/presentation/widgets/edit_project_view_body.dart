import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo_impl.dart';
import 'package:daily_activity/features/project/presentation/manager/edit_project_cubit/edit_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/edit_task.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_date_time_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/core/widgets/project_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/debug_logger.dart';

class EditProjectViewBody extends StatefulWidget {
  const EditProjectViewBody({super.key});

  @override
  State<EditProjectViewBody> createState() => _EditProjectViewBodyState();
}

class _EditProjectViewBodyState extends State<EditProjectViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<EditProjectCubit, EditProjectState>(
        listener: (context, state) {
          if (state is EditProjectSuccess) {
            GoRouter.of(context).pushReplacement(AppRouter.kLayOut);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Project updated successfully!')),
            );
          } else if (state is EditProjectError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        builder: (context, state) {
          DebugLogger.log("Start with state: $state");
          if (state is EditProjectLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final formState = state is EditProjectFormState
              ? state
              : EditProjectFormState(
                  project: ProjectModel(
                      title: "",
                      description: "",
                      category: categories[ProjectCategory.dailyStudy]!,
                      startDate: DateTime.now(),
                      endDate: DateTime.now(),
                      tasks: [],
                      status: TaskStatus.notStarted));

          // Update controllers with current form state values
          if (_titleController.text != formState.project.title) {
            _titleController.text = formState.project.title;
          }
          if (_descriptionController.text != formState.project.description) {
            _descriptionController.text = formState.project.description;
          }
          return Form(
            key: _formKey,
            autovalidateMode: autovalidateMode,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  ProjectAppBar(
                      title: "Edit Project",
                      actionButton: Text(
                        "Done",
                        style: AppTextStyles.textStyle16.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                      onActionButtonPressed: () {
                        final form = _formKey.currentState!;

                        if (form.validate()) {
                          form.save();
                          context.read<EditProjectCubit>().submitForm();
                        }
                      }),
                  CustomDropDownButton(
                    onSave: context.read<EditProjectCubit>(),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _titleController,
                    onSaved: (value) {
                      DebugLogger.log("Title in the view is $value");
                      context.read<EditProjectCubit>().titleChange(value ?? "");
                    },
                    maxLines: 1,
                    maxLength: 50,
                    hintText: 'Task Name',
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _descriptionController,
                    onSaved: (value) {
                      context
                          .read<EditProjectCubit>()
                          .descriptionChange(value ?? "");
                    },
                    minLines: 5,
                    maxLines: 6,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 30),
                  BlocProvider(
                    create: (context) => TaskCubit(TaskRepoImpl()),
                    child: EditTask(initialTasks: formState.project.tasks),
                  ),
                  const SizedBox(height: 30),
                  CustomDateTimeButton(
                    title: "Start Date",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: formState.startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        context
                            .read<EditProjectCubit>()
                            .startDateChange(pickedDate);
                      }
                    },
                    selectedDate: formState.startDate,
                  ),
                  const SizedBox(height: 30),
                  CustomDateTimeButton(
                    title: "End Date",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: formState.endDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        context
                            .read<EditProjectCubit>()
                            .endDateChange(pickedDate);
                      }
                    },
                    selectedDate: formState.endDate,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
