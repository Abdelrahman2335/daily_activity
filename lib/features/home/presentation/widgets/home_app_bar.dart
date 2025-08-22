import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/core/utils/app_text_styles.dart';
import 'package:daily_activity/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentName = context.read<SettingCubit>().currentName;
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 22, left: 19, right: 12, bottom: 11),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 12),
                child: CircleAvatar(
                  child: Icon(
                    PhosphorIcons.user(),
                    color: AppColor.accentPink,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentName != "")
                    Text(
                      "Hello!",
                      style: AppTextStyles.textStyle12(context),
                    ),
                  Text(
                    currentName == "" ? "Hello There!" : currentName,
                    style: AppTextStyles.textStyleBold12(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
