import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../manager/cubit/project_cubit.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    super.key,
    required this.onDelete,
  });

  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Are you sure you want to delete this project?'),
      actions: [
        TextButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: Text("Cancel",
              style: AppTextStyles.textStyle14
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColor.accentRed),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          onPressed: onDelete,
          child: Text("Delete",
              style: AppTextStyles.textStyle14
                  .copyWith(color: AppColor.accentRed)),
        )
      ],
    );
  }
}
