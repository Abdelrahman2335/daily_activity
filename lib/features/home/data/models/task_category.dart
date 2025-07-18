import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TaskCategory {
  work,
  personal,
  dailyStudy,
  healthFitness,
  finance,
  shopping,
  travel,
  sideProjects,
  socialEvents,
}

class TaskCategoryModel {
  final String title;
  final Color color;
  final IconData icon;

  TaskCategoryModel(
      {required this.title, required this.color, required this.icon});
}
