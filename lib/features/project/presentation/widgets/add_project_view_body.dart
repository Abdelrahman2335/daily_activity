import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_date_time_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/core/widgets/project_app_bar.dart';
import 'package:daily_activity/features/project/presentation/widgets/manage_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/debug_logger.dart';

class AddProjectViewBody extends StatefulWidget {
  const AddProjectViewBody({super.key});

  @override
  State<AddProjectViewBody> createState() => _AddProjectViewBodyState();
}

class _AddProjectViewBodyState extends State<AddProjectViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<ProjectCubit, ProjectState>(
        listener: (context, state) {
          if (state is ProjectSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text("Project update"),
                  content: Text("Project added successfully!"),
                );
              },
            );

            Future.delayed((Duration(seconds: 2)), () {
              GoRouter.of(context).pushReplacement(AppRouter.kLayOut);
            });
          } else if (state is ProjectError) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text("Error"),
                  content: Text(state.errMessage),
                );
              },
            );
            GoRouter.of(context).pop();
          }
        },
        builder: (context, state) {
          DebugLogger.log("Start with state: $state");
          if (state is ProjectLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final formState = state is ProjectFormState
              ? state
              : ProjectFormState(
                  project: ProjectModel(
                      title: "",
                      description: "",
                      category: categories[ProjectCategory.dailyStudy]!,
                      startDate: DateTime.now(),
                      endDate: DateTime.now(),
                      tasks: [],
                      status: TaskStatus.notStarted));
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
                      title: "Add Project",
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
                          context.read<ProjectCubit>().submitForm();
                        }
                      }),
                  CustomDropDownButton(
                    onSave: context.read<ProjectCubit>(),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    onSaved: (value) {
                      DebugLogger.log("Title in the view is $value");
                      context.read<ProjectCubit>().titleChange(value ?? "");
                    },
                    maxLines: 1,
                    maxLength: 50,
                    hintText: 'Task Name',
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<ProjectCubit>()
                          .descriptionChange(value ?? "");
                    },
                    minLines: 5,
                    maxLines: 6,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 30),
                  const ManageTask(),
                  const SizedBox(height: 30),
                  CustomDateTimeButton(
                    title: "Start Date",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        context
                            .read<ProjectCubit>()
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        context.read<ProjectCubit>().endDateChange(pickedDate);
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
