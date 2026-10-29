/// Unit tests for the pure reminder resolution logic.
///
/// Covers:
///  * the normal decision chain (default / custom / off),
///  * the override semantics: a project in 'custom' mode is fully
///    independent of the global config — it keeps its own schedule even
///    when the global master switch is off or a global 'selected' scope
///    targets it,
///  * corrupt-data clamping (slots, weekdays, empty weekly slots),
///  * stop conditions (completed, endDate — with injected `now`),
///  * fire-time generation (windows, exact-instant grouping),
///  * notification content builders and summaries.
library;

import 'dart:convert';

import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/services/reminder_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

ProjectModel _project({
  String id = 'p1',
  String? title,
  String? reminderMode,
  List<String>? customSlots,
  List<int>? customWeekdays,
  TaskStatus? status,
  DateTime? endDate,
  List<TaskModel>? tasks,
}) {
  return ProjectModel(
    id: id,
    title: title ?? 'Alpha',
    description: 'desc',
    category: categories[ProjectCategory.work]!,
    startDate: DateTime(2026, 1, 1),
    endDate: endDate ?? DateTime(2026, 12, 31),
    tasks: tasks ?? [TaskModel(title: 'task')],
    status: status ?? TaskStatus.notStarted,
    reminderMode: reminderMode,
    customSlots: customSlots,
    customWeekdays: customWeekdays,
  );
}

GlobalReminderConfig _global({
  bool enabled = true,
  ReminderScope scope = ReminderScope.all,
  Set<String> selectedIds = const {},
  ReminderCadence cadence = ReminderCadence.daily,
  List<String> dailySlots = const ['09:00'],
  List<int> weeklyWeekdays = const [1, 3],
  String weeklyTime = '08:00',
}) {
  return GlobalReminderConfig(
    enabled: enabled,
    scope: scope,
    selectedIds: selectedIds,
    cadence: cadence,
    dailySlots: dailySlots,
    weeklyWeekdays: weeklyWeekdays,
    weeklyTime: weeklyTime,
  );
}

void main() {
  group('effectiveReminder — normal cases', () {
    test('default project follows the global daily cadence', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'default'),
        _global(dailySlots: ['09:00', '18:30']),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.daily);
      expect(reminder.dailySlots, ['09:00', '18:30']);
    });

    test('default project follows the global weekly cadence', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'default'),
        _global(cadence: ReminderCadence.weekly, weeklyWeekdays: [2, 5]),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.weekly);
      expect(reminder.weeklyWeekdays, [2, 5]);
      expect(reminder.weeklyTime, '08:00');
    });

    test('default project is silent when the global switch is off', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'default'),
        _global(enabled: false),
      );

      expect(reminder.enabled, isFalse);
    });

    test(
        'default project is silent when scope is selected and it is not picked',
        () {
      final reminder = effectiveReminder(
        _project(id: 'p1', reminderMode: 'default'),
        _global(scope: ReminderScope.selected, selectedIds: {'other'}),
      );

      expect(reminder.enabled, isFalse);
    });

    test(
        'default project follows the global config when scope is selected '
        'and it is picked', () {
      final reminder = effectiveReminder(
        _project(id: 'p1', reminderMode: 'default'),
        _global(scope: ReminderScope.selected, selectedIds: {'p1'}),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.dailySlots, ['09:00']);
    });

    test('custom daily project uses its own slots', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'custom', customSlots: ['07:30', '19:00']),
        _global(),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.daily);
      expect(reminder.dailySlots, ['07:30', '19:00']);
    });

    test('custom weekly project uses its own weekdays and time', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['07:30'],
          customWeekdays: [1, 3, 5],
        ),
        _global(),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.weekly);
      expect(reminder.weeklyWeekdays, [1, 3, 5]);
      expect(reminder.weeklyTime, '07:30');
    });

    test('project set to off is silent', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'off'),
        _global(),
      );

      expect(reminder.enabled, isFalse);
    });
  });

  group('effectiveReminder — custom independence (override semantics)', () {
    test(
        'custom project ignores a global selected scope that targets it — '
        'the project custom schedule stays the active one', () {
      final reminder = effectiveReminder(
        _project(id: 'p1', reminderMode: 'custom', customSlots: ['07:30']),
        _global(scope: ReminderScope.selected, selectedIds: {'p1'}),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.daily);
      expect(reminder.dailySlots, ['07:30'],
          reason: 'the global selection must not leak its own slots in');
    });

    test(
        'custom project still notifies when the global master switch is off',
        () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'custom', customSlots: ['07:30', '19:00']),
        _global(enabled: false),
      );

      expect(reminder.enabled, isTrue,
          reason: 'custom mode is fully independent of the global config');
      expect(reminder.dailySlots, ['07:30', '19:00']);
    });

    test(
        'custom weekly project still notifies when the global master switch '
        'is off', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['07:30'],
          customWeekdays: [6],
        ),
        _global(enabled: false),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.weekly);
      expect(reminder.weeklyWeekdays, [6]);
      expect(reminder.weeklyTime, '07:30');
    });
  });

  group('effectiveReminder — corrupt data clamping', () {
    test('custom weekly with empty customSlots does not crash', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: const [],
          customWeekdays: [2],
        ),
        _global(),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.cadence, ReminderCadence.weekly);
      expect(reminder.weeklyTime, '09:00',
          reason: 'falls back to the default time when no slot exists');
    });

    test(
        'custom daily slots are normalized, deduplicated, sorted and capped '
        'at 3', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['12:00', '07:30', '25:00', '07:30', 'bad', '13:00'],
        ),
        _global(),
      );

      expect(reminder.dailySlots, ['07:30', '12:00', '13:00']);
    });

    test('custom daily with only invalid slots stays enabled with no slots',
        () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'custom', customSlots: ['xx', '99:99']),
        _global(),
      );

      expect(reminder.enabled, isTrue);
      expect(reminder.dailySlots, isEmpty);
    });

    test('custom weekly weekdays outside 1..7 are filtered', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['07:30'],
          customWeekdays: [0, 1, 3, 9],
        ),
        _global(),
      );

      expect(reminder.weeklyWeekdays, [1, 3]);
    });
  });

  group('effectiveReminder — stop conditions', () {
    test('completed project never notifies, even in custom mode', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['07:30'],
          status: TaskStatus.completed,
        ),
        _global(),
      );

      expect(reminder.enabled, isFalse);
    });

    test('endDate passed (now injected): silent the day after it', () {
      final reminder = effectiveReminder(
        _project(endDate: DateTime(2026, 1, 2)),
        _global(),
        now: DateTime(2026, 1, 3, 0, 0),
      );

      expect(reminder.enabled, isFalse);
    });

    test('endDate is today: still notifies (day granularity)', () {
      final reminder = effectiveReminder(
        _project(endDate: DateTime(2026, 1, 3)),
        _global(),
        now: DateTime(2026, 1, 3, 10, 0),
      );

      expect(reminder.enabled, isTrue);
    });

    test('endDate in the future: notifies', () {
      final reminder = effectiveReminder(
        _project(endDate: DateTime(2026, 1, 4)),
        _global(),
        now: DateTime(2026, 1, 3, 10, 0),
      );

      expect(reminder.enabled, isTrue);
    });
  });

  group('generateFireTimes', () {
    test('daily cadence generates one fire per slot per day for 7 days', () {
      final fires = generateFireTimes(
        projects: [_project(reminderMode: 'default')],
        global: _global(dailySlots: ['09:00']),
        now: DateTime(2026, 1, 5, 12, 0),
      );

      expect(fires.length, 7);
      final days = fires.keys.map((k) => k.day).toSet();
      expect(days, {5, 6, 7, 8, 9, 10, 11});
      expect(fires.keys.every((k) => k.hour == 9 && k.minute == 0), isTrue);
    });

    test(
        'weekly cadence fires on matching weekdays within the 14-day window',
        () {
      // Jan 5 2026 is a Monday (ISO weekday 1).
      final fires = generateFireTimes(
        projects: [
          _project(
            reminderMode: 'custom',
            customSlots: ['08:00'],
            customWeekdays: [1],
          ),
        ],
        global: _global(),
        now: DateTime(2026, 1, 5, 12, 0),
      );

      expect(fires.length, 2, reason: 'Mon Jan 5 and Mon Jan 12 within 14 days');
      for (final fire in fires.keys) {
        expect(fire.hour, 8);
        expect(fire.weekday, 1);
      }
    });

    test(
        'a custom slot colliding with a global slot at the same instant '
        'groups both projects into one digest entry', () {
      final fires = generateFireTimes(
        projects: [
          _project(
            id: 'custom',
            reminderMode: 'custom',
            customSlots: ['09:00'],
          ),
          _project(id: 'global', reminderMode: 'default'),
        ],
        global: _global(dailySlots: ['09:00']),
        now: DateTime(2026, 1, 5, 12, 0),
      );

      expect(fires.length, 7);
      for (final projects in fires.values) {
        expect(projects.map((p) => p.id).toSet(), {'custom', 'global'},
            reason: 'same instant → single grouped notification');
      }
    });

    test('disabled projects produce no fires', () {
      final fires = generateFireTimes(
        projects: [_project(reminderMode: 'off')],
        global: _global(),
        now: DateTime(2026, 1, 5, 12, 0),
      );

      expect(fires, isEmpty);
    });
  });

  group('notification content', () {
    test('individualTitle includes progress percent', () {
      final project = _project(tasks: [
        TaskModel(title: 'a', isCompleted: true),
        TaskModel(title: 'b'),
      ]);

      expect(individualTitle(project), '📌 Alpha (50%)');
    });

    test('individualBody counts remaining tasks and shows the due date', () {
      final project = _project(tasks: [
        TaskModel(title: 'a', isCompleted: true),
        TaskModel(title: 'b'),
      ]);

      expect(individualBody(project), '1 tasks remaining • Due 31 Dec, 2026');
    });

    test('digestBody for zero projects', () {
      expect(digestBody(const []), 'Projects need attention.');
    });

    test('digestBody for one project', () {
      expect(digestBody([_project()]), 'Alpha (0%) needs attention.');
    });

    test('digestBody for exactly two projects names each of them once', () {
      final body = digestBody([
        _project(),
        _project(
          id: 'p2',
          title: 'Beta',
          tasks: [
            TaskModel(title: 'a', isCompleted: true),
          ],
        ),
      ]);

      expect(body, 'Alpha (0%) and Beta (100%) need attention.',
          reason: 'the second project must not be duplicated');
    });

    test('digestBody for three projects counts the remainder', () {
      final body = digestBody([
        _project(),
        _project(id: 'p2', title: 'Beta'),
        _project(id: 'p3', title: 'Gamma'),
      ]);

      expect(body, 'Alpha (0%), Beta (0%) and 1 more need attention.');
    });

    test('digestTitle includes the count', () {
      expect(digestTitle(3), 'Flowi • 3 Active Projects Today');
    });

    test('encodePayload round-trips through jsonDecode', () {
      final payload = encodePayload(kind: 'project', projectIds: ['a', 'b']);
      final map = jsonDecode(payload) as Map<String, dynamic>;

      expect(map['kind'], 'project');
      expect(map['projectIds'], ['a', 'b']);
    });
  });

  group('summaries', () {
    test('summary is Off when disabled', () {
      expect(const ResolvedReminder.none().summary(), 'Off');
    });

    test('summary for daily cadence', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'custom', customSlots: ['07:30', '19:00']),
        _global(),
      );

      expect(reminder.summary(), 'Every day · 2x · 07:30 and 19:00');
    });

    test('summary for a single daily slot', () {
      final reminder = effectiveReminder(
        _project(reminderMode: 'custom', customSlots: ['09:00']),
        _global(),
      );

      expect(reminder.summary(), 'Every day · 1x · 09:00');
    });

    test('summary for weekly cadence', () {
      final reminder = effectiveReminder(
        _project(
          reminderMode: 'custom',
          customSlots: ['07:30'],
          customWeekdays: [1, 3, 5],
        ),
        _global(),
      );

      expect(reminder.summary(), 'Every week · Mon, Wed and Fri · 07:30');
    });

    test('globalSummary when the global switch is off', () {
      expect(globalSummary(_global(enabled: false)), 'Reminders are off');
    });

    test('globalSummary describes the global cadence', () {
      expect(
        globalSummary(_global(dailySlots: ['09:00', '18:30'])),
        'Every day · 2x · 09:00 and 18:30',
      );
    });
  });
}
