import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_calender_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCalenderList extends StatelessWidget {
  const CustomCalenderList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    final list = context.read<HomeCubit>().dateTimeList();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SliverAppBar(
          backgroundColor: Colors.transparent,
          stretch: true,
          automaticallyImplyLeading: false,
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
            height: 150,
            width: double.infinity,
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 9,
                    childAspectRatio: 1.4),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final isSelected = selectedIndex == index;
                  return CustomCalenderCard(
                    isSelected: isSelected,
                    dataTimeModel:
                        context.read<HomeCubit>().getCustomDateList[index],
                    onTap: () {
                      context.read<HomeCubit>().dateFilter(list[index]);
                    },
                  );
                }),
          )),
        );
      },
    );
  }
}
