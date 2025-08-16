import 'package:daily_activity/core/widgets/primary_button.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/project_status.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    int? selectedIndex;
    bool? isSelected;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 14,
              children: [
                PrimaryButton(
                  isSelected: isSelected == null,
                  onPressed: () {
                    context.read<HomeCubit>().clearFilters();
                    isSelected = null;
                    selectedIndex = null;
                  },
                  text: "All Projects",
                ),
                ...List.generate(TaskStatus.values.length, (index) {
                  isSelected = selectedIndex == index;
                  return PrimaryButton(
                    isSelected: isSelected ?? false,
                    onPressed: () {
                      if (selectedIndex == index) {
                        context.read<HomeCubit>().clearFilters();
                        isSelected = null;
                        selectedIndex = null;
                      } else {
                        selectedIndex = index;
                        context.read<HomeCubit>().applyStatusFilter(
                            TaskStatus.values[selectedIndex!]);
                      }
                    },
                    text: TaskStatus.values[index].displayName,
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
