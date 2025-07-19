import 'dart:ui';

import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/features/home/data/models/task_category.dart';

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

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskCategoryModel category;
  final DateTime date;
  final double progress;
  final TaskStatus status;

  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.progress = 0,
    required this.status,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
