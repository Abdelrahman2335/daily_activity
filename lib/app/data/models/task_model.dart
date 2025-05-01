import 'package:daily_activity/app/data/models/task_category.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskCategoryModel category;
  final DateTime date;
  final double progress;
  final bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.progress = 0,
    required this.isCompleted,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
