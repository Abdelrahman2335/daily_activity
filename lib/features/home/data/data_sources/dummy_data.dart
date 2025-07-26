import 'package:daily_activity/features/home/data/models/task_model.dart';
import 'package:daily_activity/features/home/data/models/task_status.dart';

import '../models/task_category.dart';
import 'categories.dart';

final List<TaskModel> dummyTasks = [
  TaskModel(
    title: 'Team Meeting',
    description:
        'Weekly sync-up with the project team to review progress and blockers.',
    category: categories[TaskCategory.work]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 60,
  ),
  TaskModel(
    title: 'Call Mom',
    description: 'Catch up and share updates about the week.',
    category: categories[TaskCategory.personal]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 30,
  ),
  TaskModel(
    title: 'Read Flutter Documentation',
    description: 'Study state management techniques in Flutter for 1 hour.',
    category: categories[TaskCategory.dailyStudy]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 75,
  ),
  TaskModel(
    title: 'Morning Workout',
    description: '45-minute strength and cardio session at the gym.',
    category: categories[TaskCategory.healthFitness]!,
    date: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress:40,
  ),
  TaskModel(
    title: 'Review Monthly Budget',
    description: 'Go over expenses and update the spreadsheet.',
    category: categories[TaskCategory.finance]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 50,
  ),
  TaskModel(
    title: 'Buy Groceries',
    description: 'Milk, eggs, chicken, oats, and fruits for the week.',
    category: categories[TaskCategory.shopping]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 20,
  ),
  TaskModel(
    title: 'Book Hotel in Cairo',
    description: 'Compare prices and finalize the 3-night booking.',
    category: categories[TaskCategory.travel]!,
    date: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress: 10,
  ),
  TaskModel(
    title: 'Finish Portfolio App',
    description: 'Complete the settings screen and submit to GitHub.',
    category: categories[TaskCategory.sideProjects]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 85,
  ),
  TaskModel(
    title: 'Attend Ahmed’s Birthday',
    description: 'Gift ready. Party at 7 PM at his place.',
    category: categories[TaskCategory.socialEvents]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 0,
  ),
];
