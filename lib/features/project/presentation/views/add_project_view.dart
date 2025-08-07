import 'package:daily_activity/core/widgets/app_background.dart';
import 'package:daily_activity/features/project/presentation/widgets/add_project_view_body.dart';
import 'package:flutter/material.dart';

class AddProjectView extends StatelessWidget {
  const AddProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(children: const [
      AddProjectViewBody(),
    ]);
  }
}
