import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

final Uuid _uuid = Uuid();

@HiveType(typeId: 3) // Use a unique typeId for each class
class TaskModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;


  @HiveField(4)
  final bool? isCompleted;

  TaskModel({
    required this.title,
    String? id,
    bool? isCompleted,
  })  : id = id ?? _uuid.v4(),
        isCompleted = isCompleted ?? false;
}
