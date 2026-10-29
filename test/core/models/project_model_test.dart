/// Regression tests for ProjectModel.copyWith and the reminder fields.
///
/// Bug this guards against: copyWith declared the reminder parameters but
/// never forwarded them to the constructor, so any edit (title, tasks,
/// status…) silently reset the per-project reminder to 'default'.
library;

import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

ProjectModel _project() {
  return ProjectModel(
    id: 'p1',
    title: 'Alpha',
    description: 'desc',
    category: categories[ProjectCategory.work]!,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 12, 31),
    tasks: [TaskModel(title: 'task')],
    status: TaskStatus.notStarted,
    reminderMode: 'custom',
    customSlots: const ['07:30', '19:00'],
    customWeekdays: const [1, 3],
  );
}

void main() {
  test('copyWith preserves the reminder fields on unrelated edits', () {
    final copy = _project().copyWith(title: 'New title');

    expect(copy.reminderMode, 'custom');
    expect(copy.customSlots, const ['07:30', '19:00']);
    expect(copy.customWeekdays, const [1, 3]);
    expect(copy.title, 'New title');
  });

  test('copyWith honors explicit reminder-field changes', () {
    final original = _project();

    expect(original.copyWith(reminderMode: 'off').reminderMode, 'off');
    expect(
      original.copyWith(customSlots: const ['10:00']).customSlots,
      const ['10:00'],
    );
    expect(
      original.copyWith(customWeekdays: const [5]).customWeekdays,
      const [5],
    );
  });

  test('copyWith preserves the original id', () {
    expect(_project().copyWith(title: 'New').id, 'p1');
  });
}
