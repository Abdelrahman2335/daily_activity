import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'task_category.g.dart';

@HiveType(typeId: 1)
enum TaskCategory {
  @HiveField(0)
  work,
  @HiveField(1)
  personal,
  @HiveField(2)
  dailyStudy,
  @HiveField(3)
  healthFitness,
  @HiveField(4)
  finance,
  @HiveField(5)
  shopping,
  @HiveField(6)
  travel,
  @HiveField(7)
  sideProjects,
  @HiveField(8)
  socialEvents,
}

class TaskCategoryModel {
  final String title;
  final Color color;
  final IconData icon;

  TaskCategoryModel(
      {required this.title, required this.color, required this.icon});
}
