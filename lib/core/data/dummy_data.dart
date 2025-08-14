import '../../../../core/models/project_category.dart';
import '../../../../core/models/project_model.dart';
import '../../../../core/models/project_status.dart';
import 'categories.dart';

final List<ProjectModel> dummyTasks = [
  ProjectModel(
    title: 'Team Meeting',
    description:
        'Weekly sync-up with the project team to review progress and blockers.',
    category: categories[ProjectCategory.work]!,
    startDate: DateTime.now(),
    status: TaskStatus.inProgress,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Call Mom',
    description: 'Catch up and share updates about the week.',
    category: categories[ProjectCategory.personal]!,
    startDate: DateTime.now(),
    status: TaskStatus.completed,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Read Flutter Documentation',
    description: 'Study state management techniques in Flutter for 1 hour.',
    category: categories[ProjectCategory.dailyStudy]!,
    startDate: DateTime.now(),
    status: TaskStatus.inProgress,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Morning Workout',
    description: '45-minute strength and cardio session at the gym.',
    category: categories[ProjectCategory.healthFitness]!,
    startDate: DateTime.now(),
    status: TaskStatus.notStarted,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Review Monthly Budget',
    description: 'Go over expenses and update the spreadsheet.',
    category: categories[ProjectCategory.finance]!,
    startDate: DateTime.now(),
    status: TaskStatus.completed,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Buy Groceries',
    description: 'Milk, eggs, chicken, oats, and fruits for the week.',
    category: categories[ProjectCategory.shopping]!,
    startDate: DateTime.now(),
    status: TaskStatus.inProgress,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Book Hotel in Cairo',
    description: 'Compare prices and finalize the 3-night booking.',
    category: categories[ProjectCategory.travel]!,
    startDate: DateTime.now(),
    status: TaskStatus.notStarted,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Finish Portfolio App',
    description: 'Complete the settings screen and submit to GitHub.',
    category: categories[ProjectCategory.sideProjects]!,
    startDate: DateTime.now(),
    status: TaskStatus.inProgress,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
  ProjectModel(
    title: 'Attend Ahmed’s Birthday',
    description: 'Gift ready. Party at 7 PM at his place.',
    category: categories[ProjectCategory.socialEvents]!,
    startDate: DateTime.now(),
    status: TaskStatus.completed,
    tasks: [],
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
];