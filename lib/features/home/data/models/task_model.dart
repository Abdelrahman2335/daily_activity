import 'package:daily_activity/features/home/data/models/task_category.dart';
import 'package:daily_activity/features/home/data/models/task_status.dart';

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
