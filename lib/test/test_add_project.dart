import 'dart:math';
import 'package:daily_activity/core/data/categories.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';

class TestAddProject {
  static final Random _random = Random();

  // Sample data for random generation
  static final List<String> _projectTitles = [
    "Build Mobile App",
    "Learn Flutter Development",
    "Complete Personal Website",
    "Study Data Structures",
    "Fitness Challenge",
    "Read 10 Books",
    "Plan Vacation Trip",
    "Organize Home Office",
    "Start Side Business",
    "Master Cooking Skills",
    "Learn New Language",
    "Photography Project",
    "Garden Renovation",
    "Budget Planning",
    "Health Checkup",
  ];

  static final List<String> _descriptions = [
    "A comprehensive project to improve productivity and achieve goals.",
    "This project focuses on developing new skills and expanding knowledge.",
    "An exciting challenge that will push boundaries and create value.",
    "Important initiative to enhance personal and professional growth.",
    "Strategic project aimed at long-term success and satisfaction.",
    "Creative endeavor that combines passion with practical outcomes.",
    "Essential project for maintaining balance and well-being.",
    "Innovative approach to solving everyday challenges.",
    "Meaningful project that contributes to personal development.",
    "Collaborative effort to achieve ambitious objectives.",
  ];

  static final List<String> _taskTitles = [
    "Research and planning",
    "Setup development environment",
    "Create initial prototype",
    "Design user interface",
    "Implement core features",
    "Write documentation",
    "Test functionality",
    "Review and optimize",
    "Deploy to production",
    "Gather feedback",
    "Create backup plan",
    "Schedule meetings",
    "Prepare materials",
    "Practice presentation",
    "Final review",
  ];

  // Generate a single random project
  static ProjectModel generateRandomProject() {
    final title = _projectTitles[_random.nextInt(_projectTitles.length)];
    final description = _descriptions[_random.nextInt(_descriptions.length)];
    final category =
        categories.values.elementAt(_random.nextInt(categories.length));

    // Random date range (within next 6 months)
    final startDate = DateTime.now().add(Duration(days: _random.nextInt(30)));
    final endDate = startDate.add(Duration(days: _random.nextInt(90) + 7));

    // Generate random tasks (2-6 tasks)
    final taskCount = _random.nextInt(5) + 2;
    final tasks = List.generate(taskCount, (index) {
      return TaskModel(
        title: _taskTitles[_random.nextInt(_taskTitles.length)],
        isCompleted: _random.nextBool(),
      );
    });

    // Determine status based on task completion
    TaskStatus status;
    final completedTasks =
        tasks.where((task) => task.isCompleted == true).length;
    if (completedTasks == tasks.length) {
      status = TaskStatus.completed;
    } else if (completedTasks > 0) {
      status = TaskStatus.inProgress;
    } else {
      status = TaskStatus.notStarted;
    }

    return ProjectModel(
      title: title,
      description: description,
      category: category,
      startDate: startDate,
      endDate: endDate,
      tasks: tasks,
      status: status,
    );
  }

  // Generate multiple random projects
  static List<ProjectModel> generateRandomProjects(int count) {
    return List.generate(count, (index) => generateRandomProject());
  }

  // Pre-defined test project (keeping for compatibility)
  final testProject = ProjectModel(
    title: "Sample Test Project",
    description: "This is a sample project for testing purposes",
    category: categories.values.elementAt(6),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
    tasks: [
      TaskModel(title: "Setup project structure", isCompleted: false),
      TaskModel(title: "Implement core features", isCompleted: true),
      TaskModel(title: "Write unit tests", isCompleted: true),
      TaskModel(title: "Deploy to staging", isCompleted: true),
    ],
    status: TaskStatus.inProgress,
  );
}
