import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/widgets/project_app_bar.dart';
import 'package:daily_activity/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_date_time_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/manage_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/debug_logger.dart';
import 'alert_dialog.dart';

class EditProjectViewBody extends StatefulWidget {
  const EditProjectViewBody({super.key});

  @override
  State<EditProjectViewBody> createState() => _EditProjectViewBodyState();
}

class _EditProjectViewBodyState extends State<EditProjectViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<ProjectCubit, ProjectState>(
        listener: (context, state) {
          if (state is ProjectSuccess) {
            GoRouter.of(context).pushReplacement(AppRouter.kLayOut);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text("Project Update"),
                  content: Text("Project updated successfully!"),
                );
              },
            );
            GoRouter.of(context).pop();
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
            Future.delayed((Duration(seconds: 2)), () {
              GoRouter.maybeOf(context)?.pop();
            });
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
            autovalidateMode: autoValidateMode,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                spacing: 30,
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
                          context.read<ProjectCubit>().submitForm();
                        }
                      }),
                  CustomDropDownButton(
                    initialValue: formState.category,
                    onSave: context.read<ProjectCubit>(),
                  ),
                  CustomTextFormField(
                    initialValue: formState.title,
                    onSaved: (value) {
                      context.read<ProjectCubit>().titleChange(value ?? "");
                    },
                    maxLines: 1,
                    maxLength: 50,
                    hintText: 'Project Name',
                  ),
                  CustomTextFormField(
                    initialValue: formState.description,
                    onSaved: (value) {
                      context
                          .read<ProjectCubit>()
                          .descriptionChange(value ?? "");
                    },
                    minLines: 5,
                    maxLines: 6,
                    hintText: 'Description',
                  ),
                  const ManageTask(),
                  CustomDateTimeButton(
                    title: "Start Date",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: formState.startDate,
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
                  CustomDateTimeButton(
                    title: "End Date",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: formState.endDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        context.read<ProjectCubit>().endDateChange(pickedDate);
                      }
                    },
                    selectedDate: formState.endDate,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.accentRed),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertWidget(formState: formState);
                            });
                        // context
                        //     .read<ProjectCubit>()
                        //     .deleteProject(projectId: formState.project.id);
                      },
                      child: Text(
                        "Delete Project",
                        style: AppTextStyles.textStyle14
                            .copyWith(color: AppColor.accentRed),
                      )),
                  const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
