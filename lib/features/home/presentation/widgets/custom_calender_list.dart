import 'package:daily_activity/features/home/data/models/data_time_model.dart';
import 'package:daily_activity/features/home/presentation/widgets/custom_calender_card.dart';
import 'package:flutter/material.dart';

class CustomCalenderList extends StatefulWidget {
  const CustomCalenderList({
    super.key,
  });

  @override
  State<CustomCalenderList> createState() => _CustomCalenderListState();
}

class _CustomCalenderListState extends State<CustomCalenderList> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<DataTimeModel> testCalender = [
      DataTimeModel(month: "May", day: "25", weekday: "Sun"),
      DataTimeModel(month: "Jun", day: "26", weekday: "Mon"),
      DataTimeModel(month: "Jul", day: "27", weekday: "Tue"),
      DataTimeModel(month: "Aug", day: "28", weekday: "Wed"),
      DataTimeModel(month: "Sep", day: "29", weekday: "Thu"),
      DataTimeModel(month: "Oct", day: "30", weekday: "Fri"),
      DataTimeModel(month: "Nov", day: "31", weekday: "Sat"),
    ];
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
            itemCount: testCalender.length,
            itemBuilder: (BuildContext context, int index) {
              final isSelected = selectedIndex == index;
              return CustomCalenderCard(
                isSelected: isSelected,
                dataTimeModel: testCalender[index],
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            }),
      )),
    );
  }
}
