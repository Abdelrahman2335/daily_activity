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
    startDate: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 60,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Call Mom',
    description: 'Catch up and share updates about the week.',
    category: categories[ProjectCategory.personal]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 30,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Read Flutter Documentation',
    description: 'Study state management techniques in Flutter for 1 hour.',
    category: categories[ProjectCategory.dailyStudy]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 75,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Morning Workout',
    description: '45-minute strength and cardio session at the gym.',
    category: categories[ProjectCategory.healthFitness]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress: 40,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Review Monthly Budget',
    description: 'Go over expenses and update the spreadsheet.',
    category: categories[ProjectCategory.finance]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 50,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Buy Groceries',
    description: 'Milk, eggs, chicken, oats, and fruits for the week.',
    category: categories[ProjectCategory.shopping]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 20,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Book Hotel in Cairo',
    description: 'Compare prices and finalize the 3-night booking.',
    category: categories[ProjectCategory.travel]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.notStarted,
    progress: 10,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Finish Portfolio App',
    description: 'Complete the settings screen and submit to GitHub.',
    category: categories[ProjectCategory.sideProjects]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.inProgress,
    progress: 85,
    tasks: [], endDate: '',
  ),
  ProjectModel(
    title: 'Attend Ahmed’s Birthday',
    description: 'Gift ready. Party at 7 PM at his place.',
    category: categories[ProjectCategory.socialEvents]!,
    startDate: DateTime.now().toString(),
    status: TaskStatus.completed,
    progress: 0,
    tasks: [], endDate: '',
  ),
];
