import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_validators.dart';
import 'package:flutter_test/flutter_test.dart';

ProjectModel _project({
  String title = 'Title',
  String description = 'Description',
  List<TaskModel>? tasks,
}) {
  return ProjectModel(
    title: title,
    description: description,
    category: categories.values.first,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 2),
    tasks: tasks ?? [TaskModel(title: 'Task')],
    status: TaskStatus.notStarted,
  );
}

void main() {
  group('requiredField', () {
    test('accepts non-empty text', () {
      expect(ProjectValidators.requiredField('abc'), isNull);
    });

    test('rejects null, empty and whitespace-only text', () {
      expect(ProjectValidators.requiredField(null), isNotNull);
      expect(ProjectValidators.requiredField(''), isNotNull);
      expect(ProjectValidators.requiredField('   '), isNotNull);
      expect(ProjectValidators.requiredField('\n\t '), isNotNull);
    });
  });

  group('isTaskListValid', () {
    test('is false for an empty list', () {
      expect(ProjectValidators.isTaskListValid([]), isFalse);
    });

    test('is false when any task title is blank', () {
      expect(
        ProjectValidators.isTaskListValid([
          TaskModel(title: 'ok'),
          TaskModel(title: '  '),
        ]),
        isFalse,
      );
    });

    test('is true when every task has a title', () {
      expect(
        ProjectValidators.isTaskListValid([
          TaskModel(title: 'one'),
          TaskModel(title: 'two'),
        ]),
        isTrue,
      );
    });
  });

  group('isFormValid', () {
    test('is true for a complete project', () {
      expect(ProjectValidators.isFormValid(_project()), isTrue);
    });

    test('is false when the title is blank', () {
      expect(ProjectValidators.isFormValid(_project(title: ' ')), isFalse);
    });

    test('is false when the description is blank', () {
      expect(ProjectValidators.isFormValid(_project(description: '')),
          isFalse);
    });

    test('is false when there are no tasks', () {
      expect(ProjectValidators.isFormValid(_project(tasks: [])), isFalse);
    });
  });
}
