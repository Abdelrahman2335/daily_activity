import 'package:daily_activity/test/test_add_project.dart';
import 'package:flutter/material.dart';

/// Example usage of the random project generator
void main() {
  // Generate a single random project
  final randomProject = TestAddProject.generateRandomProject();
  print('Random Project: ${randomProject.title}');
  print('Description: ${randomProject.description}');
  print('Category: ${randomProject.category.title}');
  print('Tasks: ${randomProject.tasks.length}');
  print('Status: ${randomProject.status}');
  print('---');

  // Generate multiple random projects
  final multipleProjects = TestAddProject.generateRandomProjects(5);
  print('Generated ${multipleProjects.length} random projects:');

  for (int i = 0; i < multipleProjects.length; i++) {
    final project = multipleProjects[i];
    print('${i + 1}. ${project.title} - ${project.category.title}');
  }
}

/// Widget example showing how to use in your app
class RandomProjectExample extends StatelessWidget {
  const RandomProjectExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Projects')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Generate and use a random project
              final project = TestAddProject.generateRandomProject();

              // You can now use this project to:
              // - Add to your repository
              // - Display in UI
              // - Use for testing

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Created: ${project.title}')),
              );
            },
            child: Text('Generate Random Project'),
          ),
          ElevatedButton(
            onPressed: () {
              // Generate multiple projects for testing
              final projects = TestAddProject.generateRandomProjects(10);

              // Add all projects to your repository here
              // for (final project in projects) {
              //   await projectRepository.addProject(project: project);
              // }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Generated ${projects.length} projects')),
              );
            },
            child: Text('Generate 10 Random Projects'),
          ),
        ],
      ),
    );
  }
}
