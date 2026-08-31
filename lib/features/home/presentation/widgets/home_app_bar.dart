import 'package:flowi/core/utils/app_text_styles.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentName = context.read<SettingCubit>().currentName;
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 22, left: 23, right: 12, bottom: 11),
          child: Column(
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
        ),
      ),
    );
  }
}
