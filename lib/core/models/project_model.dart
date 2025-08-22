import 'package:daily_activity/core/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'project_category.dart';
import 'project_status.dart';

part 'project_model.g.dart';

final Uuid _uid = Uuid();

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
  @HiveField(8)
  final DateTime lastModified;

  ProjectModel({
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.tasks,
    String? id,
    required this.status,
    DateTime? lastModified,
  })  : id = id ?? _uid.v4(),
        lastModified = lastModified ?? DateTime.now();

  String get formattedStartDate => DateFormat('dd MMM, yyyy').format(startDate);
  String get formattedEndDate => DateFormat('dd MMM, yyyy').format(endDate);
  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completedTasks =
        tasks.where((t) => t.isCompleted ?? false).toList().length;
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
    // IMPORTANT: we must pass the existing id so we don't generate a new one.
    // Otherwise every call to copyWith() creates a new ProjectModel with a new id
    // (because the constructor auto-generates when id is null), and the repository
    // can't find the original record to update, leading to "Project not found for updating".
    return ProjectModel(
      id: id ?? this.id, // preserve original id unless explicitly overridden
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      lastModified: DateTime.now(), // bump modification timestamp
    );
  }
}
