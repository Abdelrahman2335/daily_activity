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
  final String date;
  @HiveField(5)
  final int progress;
  @HiveField(6)
  final TaskStatus status;
  @HiveField(7)
  final String tasks;

  ProjectModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.tasks,
    this.progress = 0,
    required this.status,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
