import 'package:daily_activity/core/widgets/primary_button.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/project_status.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});


  @override
  Widget build(BuildContext context) {
  int selectedIndex = 0;
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(TaskStatus.values.length, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: PrimaryButton(
                    isSelected: isSelected,
                    onPressed: () {
                      selectedIndex = index;
                      context
                          .read<HomeCubit>()
                          .statusFilter(TaskStatus.values[selectedIndex]);
                    },
                    text: TaskStatus.values[index].displayName,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
