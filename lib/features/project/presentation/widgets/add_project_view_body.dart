import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/core/widgets/custom_text_form_field.dart';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/features/project/data/project_repository/project_repo_impl.dart';
import 'package:daily_activity/features/project/data/task_repository/task_repo_impl.dart';
import 'package:daily_activity/features/project/presentation/manager/add_project_cubit/add_project_cubit.dart';
import 'package:daily_activity/features/project/presentation/manager/task_cubit/task_cubit.dart';
import 'package:daily_activity/features/project/presentation/widgets/add_task.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_date_time_button.dart';
import 'package:daily_activity/features/project/presentation/widgets/custom_drop_down_button.dart';
import 'package:daily_activity/core/widgets/project_app_bar.dart';
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

  String? taskTitle, description;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProjectCubit(ProjectRepositoryImpl()),
      child: SingleChildScrollView(
        child: BlocConsumer<AddProjectCubit, AddProjectState>(
          listener: (context, state) {
            if (state is AddProjectSuccess) {
              GoRouter.of(context).pushReplacement(AppRouter.kLayOut);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project added successfully!')),
              );
            } else if (state is AddProjectError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errMessage)));
            }
          },
          builder: (context, state) {
            DebugLogger.log("Start with state: $state");
            if (state is AddProjectLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final formState = state is AddProjectFormState
                ? state
                : AddProjectFormState(
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
                          context.read<AddProjectCubit>().submitForm();
                           }
                        }),
                    const CustomDropDownButton(),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      onSaved: (value) {
                        DebugLogger.log("Title in the view is $value");
                        context
                            .read<AddProjectCubit>()
                            .titleChange(value ?? "");
                      },
                      maxLines: 1,
                      maxLength: 50,
                      hintText: 'Task Name',
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      onSaved: (value) {
                        context
                            .read<AddProjectCubit>()
                            .descriptionChange(value ?? "");
                      },
                      minLines: 5,
                      maxLines: 6,
                      hintText: 'Description',
                    ),
                    const SizedBox(height: 30),
                    BlocProvider(
                      create: (context) => TaskCubit(TaskRepoImpl()),
                      child: AddTask(),
                    ),
                    const SizedBox(height: 30),
                    CustomDateTimeButton(
                      title: "Start Date",
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        pickedDate ?? DateTime.now();

                        context
                            .read<AddProjectCubit>()
                            .startDateChange(pickedDate!);
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
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        pickedDate ?? DateTime.now();

                        context
                            .read<AddProjectCubit>()
                            .endDateChange(pickedDate!);
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
      ),
    );
  }
}
