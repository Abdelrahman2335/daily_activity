import 'dart:ui';

import 'package:daily_activity/core/utils/app_colors.dart';

enum TaskStatus {
  notStarted,
  inProgress,
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
