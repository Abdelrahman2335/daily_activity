import 'package:daily_activity/core/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'project_category.dart';
import 'project_status.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final ProjectCategoryModel category;
  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;
  @HiveField(6)
  final TaskStatus status;
  @HiveField(7)
  final List<TaskModel> tasks;

  ProjectModel({
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.tasks,
    required this.status,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  String get formattedStartDate => DateFormat('dd MMM, yyyy').format(startDate);
  String get formattedEndDate => DateFormat('dd MMM, yyyy').format(endDate);
  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completedTasks = tasks.where((t) => t.isCompleted ?? false).toList().length;
    return completedTasks / tasks.length; // 0.0 → 1.0
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    ProjectCategoryModel? category,
    DateTime? startDate,
    DateTime? endDate,
    TaskStatus? status,
    List<TaskModel>? tasks,
  }) {
    return ProjectModel(
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        tasks: tasks ?? this.tasks,
        status: status ?? this.status);
  }
}
