import 'package:hive/hive.dart';

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
  final String startDate;
  @HiveField(5)
  final String endDate;
  @HiveField(6)
  final int progress;
  @HiveField(7)
  final TaskStatus status;
  @HiveField(8)
  final List<String> tasks;

  ProjectModel({
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.tasks,
    this.progress = 0,
    required this.status,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    ProjectCategoryModel? category,
    String? startDate,
    String? endDate,
    int? progress,
    TaskStatus? status,
    List<String>? tasks,
  }) 
  
  {
    return ProjectModel(
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        progress: progress ?? this.progress,
        tasks: tasks ?? this.tasks,
        status: status ?? this.status);
  }
}
