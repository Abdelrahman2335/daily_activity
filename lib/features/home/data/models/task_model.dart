import 'package:daily_activity/features/home/data/models/task_category.dart';
import 'package:daily_activity/features/home/data/models/task_status.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final TaskCategoryModel category;
  @HiveField(4)
  final String date;
  @HiveField(5)
  final int progress;
  @HiveField(6)
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
