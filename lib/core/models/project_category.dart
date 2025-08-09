import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'project_category.g.dart';

@HiveType(typeId: 1)
enum ProjectCategory {
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

@HiveType(typeId: 4) // Add HiveType with unique typeId
class ProjectCategoryModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final int colorValue; // Store color as int

  @HiveField(2)
  final IconData icon; 

  ProjectCategoryModel({
    required this.title,
    required this.colorValue,
    required this.icon,
  });
}
