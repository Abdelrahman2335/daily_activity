import 'dart:ui';

import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:hive/hive.dart';
part 'task_status.g.dart';
@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(0)
  notStarted,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.notStarted:
        return 'Not Started';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.notStarted:
        return AppColor.accentLightPurple;
      case TaskStatus.inProgress:
        return AppColor.accentOrange;
      case TaskStatus.completed:
        return AppColor.accentPurple;
    }
  }
}
