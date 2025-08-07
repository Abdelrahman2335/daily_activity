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
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 60,
    tasks: '',
  ),
  ProjectModel(
    title: 'Call Mom',
    description: 'Catch up and share updates about the week.',
    category: categories[ProjectCategory.personal]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 30,
    tasks: '',
  ),
  ProjectModel(
    title: 'Read Flutter Documentation',
    description: 'Study state management techniques in Flutter for 1 hour.',
    category: categories[ProjectCategory.dailyStudy]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 75,
    tasks: '',
  ),
  ProjectModel(
    title: 'Morning Workout',
    description: '45-minute strength and cardio session at the gym.',
    category: categories[ProjectCategory.healthFitness]!,
    date: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress: 40,
    tasks: '',
  ),
  ProjectModel(
    title: 'Review Monthly Budget',
    description: 'Go over expenses and update the spreadsheet.',
    category: categories[ProjectCategory.finance]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 50,
    tasks: '',
  ),
  ProjectModel(
    title: 'Buy Groceries',
    description: 'Milk, eggs, chicken, oats, and fruits for the week.',
    category: categories[ProjectCategory.shopping]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 20,
    tasks: '',
  ),
  ProjectModel(
    title: 'Book Hotel in Cairo',
    description: 'Compare prices and finalize the 3-night booking.',
    category: categories[ProjectCategory.travel]!,
    date: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress: 10,
    tasks: '',
  ),
  ProjectModel(
    title: 'Finish Portfolio App',
    description: 'Complete the settings screen and submit to GitHub.',
    category: categories[ProjectCategory.sideProjects]!,
    date: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 85,
    tasks: '',
  ),
  ProjectModel(
    title: 'Attend Ahmed’s Birthday',
    description: 'Gift ready. Party at 7 PM at his place.',
    category: categories[ProjectCategory.socialEvents]!,
    date: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 0,
    tasks: '',
  ),
];
