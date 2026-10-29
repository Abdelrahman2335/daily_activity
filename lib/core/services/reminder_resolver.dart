/// Pure reminder resolution logic — no plugin imports.
///
/// Decides
///  1. which projects should notify at all ([effectiveReminder]) and
///  2. when the fire times are ([generateFireTimes]), already grouped by
///     exact instant for the collision rule,
///  3. what each notification should look like ([individualTitle],
///     [individualBody], [digestTitle], [digestBody], [encodePayload]).
///
/// Depends only on models, so it is deterministic and testable.
library;

import 'dart:convert';

import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/reminder_config.dart';

/// A reminder configuration that finally applies to a project after merging
/// the per-project override with the global defaults.
class ResolvedReminder {
  final ReminderCadence cadence;

  /// 'HH:mm' strings for the daily cadence (only meaningful when [cadence]
  /// is daily).
  final List<String> dailySlots;

  /// ISO weekdays (1=Mon..7=Sun) for the weekly cadence.
  final List<int> weeklyWeekdays;

  /// 'HH:mm' weekly time.
  final String weeklyTime;

  /// False when nothing should notify for this project.
  final bool enabled;

  const ResolvedReminder({
    required this.cadence,
    required this.dailySlots,
    required this.weeklyWeekdays,
    required this.weeklyTime,
    required this.enabled,
  });

  const ResolvedReminder.none()
      : cadence = ReminderCadence.daily,
        dailySlots = const [],
        weeklyWeekdays = const [],
        weeklyTime = '09:00',
        enabled = false;

  /// Human summary used by the per-project UI, e.g.
  /// 'Every day · 2x · 09:00, 18:30' or 'Every week · Mon, Wed · 09:00'.
  String summary() {
    if (!enabled) return 'Off';
    if (cadence == ReminderCadence.daily) {
      return 'Every day · ${dailySlots.length}x · ${_joinAnd(dailySlots)}';
    }
    return 'Every week · ${_joinAnd(_dayNames(weeklyWeekdays))} · $weeklyTime';
  }
}

/// The effective reminder for a single project.
///
/// Stop conditions checked in order:
///  * status == completed → none,
///  * end date has passed (day granularity: never notify on or after the
///    midnight following the recorded end date) → none,
///  * reminderMode == 'off' → none,
///  * reminderMode == 'custom' → per-project config (still requires the
///    global master switch to be on),
///  * otherwise 'default'/null → global scope resolution.
ResolvedReminder effectiveReminder(
    ProjectModel project, GlobalReminderConfig global,
    {DateTime? now}) {
  return resolveReminder(
    status: project.status,
    endDate: project.endDate,
    projectId: project.id,
    reminderMode: project.reminderMode,
    customSlots: project.customSlots,
    customWeekdays: project.customWeekdays,
    global: global,
    now: now,
  );
}

/// Same decision chain as [effectiveReminder], but taking the reminder
/// fields directly. Used by the form UI to show what an unsaved custom
/// schedule will actually produce — one source of truth for both.
ResolvedReminder resolveReminder({
  required TaskStatus status,
  required DateTime endDate,
  required String projectId,
  String? reminderMode,
  List<String>? customSlots,
  List<int>? customWeekdays,
  required GlobalReminderConfig global,
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  if (status == TaskStatus.completed) {
    return const ResolvedReminder.none();
  }
  if (_endDatePassed(endDate, at)) {
    return const ResolvedReminder.none();
  }

  final mode = reminderMode;
  if (mode == 'off') return const ResolvedReminder.none();

  if (mode == 'custom') {
    // Custom mode is fully independent of the global config: the project
    // follows its own schedule even when the global master switch is off
    // or a global 'selected' scope happens to target this project.
    final weekdays = customWeekdays;
    if (weekdays != null) {
      final validWeekdays =
          weekdays.where((d) => d >= 1 && d <= 7).toSet().toList()..sort();
      return ResolvedReminder(
        cadence: ReminderCadence.weekly,
        dailySlots: const [],
        weeklyWeekdays: validWeekdays,
        // A weekly custom project keeps its single time in customSlots[0].
        weeklyTime: _firstValidSlot(customSlots) ?? '09:00',
        enabled: true,
      );
    }
    return ResolvedReminder(
      cadence: ReminderCadence.daily,
      dailySlots: _clampSlots(customSlots ?? const []),
      weeklyWeekdays: const [],
      weeklyTime: '09:00',
      enabled: true,
    );
  }

  // 'default' or null → follow the global config.
  if (!global.enabled) return const ResolvedReminder.none();
  if (global.scope == ReminderScope.selected &&
      !global.selectedIds.contains(projectId)) {
    return const ResolvedReminder.none();
  }
  if (global.cadence == ReminderCadence.weekly) {
    return ResolvedReminder(
      cadence: ReminderCadence.weekly,
      dailySlots: const [],
      weeklyWeekdays: global.weeklyWeekdays,
      weeklyTime: global.weeklyTime,
      enabled: true,
    );
  }
  return ResolvedReminder(
    cadence: ReminderCadence.daily,
    dailySlots: _clampSlots(global.dailySlots),
    weeklyWeekdays: const [],
    weeklyTime: '09:00',
    enabled: true,
  );
}

/// Summary of the global config as seen from a project set to 'default',
/// e.g. 'Every week · Mon · 09:00'.
String globalSummary(GlobalReminderConfig global) {
  if (!global.enabled) return 'Reminders are off';
  return ResolvedReminder(
    cadence: global.cadence,
    dailySlots: _clampSlots(global.dailySlots),
    weeklyWeekdays: global.weeklyWeekdays,
    weeklyTime: global.weeklyTime,
    enabled: true,
  ).summary();
}

// ---------------------------------------------------------------------------
// Fire-time generation
// ---------------------------------------------------------------------------

/// Computes the fire DateTimes for all [projects] whose effective reminder
/// is enabled, and groups them by exact instant.
///
/// Fire-time collision rule: two projects firing at the same exact instant
/// become a single digest notification; a single project at an instant
/// becomes an individual one.
///
/// Rolling window: daily slots generate for the next 7 days, weekly slots
/// for the next 14 days (to always cover the next matching weekday).
/// Output is deterministic for identical inputs.
Map<DateTime, List<ProjectModel>> generateFireTimes({
  required List<ProjectModel> projects,
  required GlobalReminderConfig global,
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final today = DateTime(at.year, at.month, at.day);
  // Exact fire instant → project ids; a set because a project could
  // theoretically land on the same instant twice.
  final fireTimes = <DateTime, Set<String>>{};

  void addTimes(List<DateTime> times, String projectId) {
    for (final time in times) {
      fireTimes.putIfAbsent(time, () => <String>{}).add(projectId);
    }
  }

  for (final project in projects) {
    final reminder = effectiveReminder(project, global, now: at);
    if (!reminder.enabled) continue;

    if (reminder.cadence == ReminderCadence.daily) {
      // Next 7 days, one fire per slot per day.
      for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
        final day = today.add(Duration(days: dayIndex));
        for (final slot in reminder.dailySlots) {
          addTimes([_combine(day, slot)], project.id);
        }
      }
    } else {
      // Next 14 days: always covers the next matching weekday.
      for (var dayIndex = 0; dayIndex < 14; dayIndex++) {
        final day = today.add(Duration(days: dayIndex));
        if (reminder.weeklyWeekdays.contains(_isoWeekday(day))) {
          addTimes([_combine(day, reminder.weeklyTime)], project.id);
        }
      }
    }
  }

  // Translate ids back to their models so callers have everything they
  // need for titles/bodies/payloads.
  final byId = {for (final p in projects) p.id: p};
  return {
    for (final entry in fireTimes.entries)
      entry.key: [
        for (final id in entry.value)
          if (byId[id] != null) byId[id]!,
      ],
  };
}

/// True when today is strictly after the project's end date (any position
/// within the end date day still notifies). [at] is injected so the check
/// is deterministic in tests.
bool _endDatePassed(DateTime endDate, DateTime at) {
  final endMidnight = DateTime(
    endDate.year,
    endDate.month,
    endDate.day,
  );
  final todayMidnight = DateTime(at.year, at.month, at.day);
  // Notify up to and including the end date; the day AFTER the end date
  // the reminder is dead.
  return todayMidnight.isAfter(endMidnight);
}

/// First valid normalized slot of a possibly null or empty list, or null
/// when there is none. Never throws on an empty list.
String? _firstValidSlot(List<String>? slots) {
  if (slots == null) return null;
  for (final slot in slots) {
    final normalized = _normalizeTime(slot);
    if (normalized != null) return normalized;
  }
  return null;
}

/// Clamps the slot list to the 3-slot maximum, keeping only valid 'HH:mm'
/// strings, sorted and deduplicated.
List<String> _clampSlots(List<String> slots) {
  final valid = <String>[];
  for (final slot in slots) {
    final normalized = _normalizeTime(slot);
    if (normalized != null && !valid.contains(normalized)) {
      valid.add(normalized);
    }
  }
  valid.sort();
  return valid.take(3).toList();
}

String? _normalizeTime(String raw) {
  final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw.trim());
  if (match == null) return null;
  final hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Combines a day (any time-of-day is discarded) with an 'HH:mm' time.
DateTime _combine(DateTime day, String time) {
  final parts = time.split(':');
  return DateTime(
    day.year,
    day.month,
    day.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

/// 1=Monday .. 7=Sunday (DateTime.weekday already follows this ISO scheme).
int _isoWeekday(DateTime day) => day.weekday;

const List<String> _kDayNames = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

List<String> _dayNames(List<int> isoWeekdays) {
  final names = <String>[
    for (final day in isoWeekdays)
      if (day >= 1 && day <= 7) _kDayNames[day - 1],
  ];
  names.sort((a, b) => _kDayNames.indexOf(a).compareTo(_kDayNames.indexOf(b)));
  return names;
}

String _joinAnd(List<String> items) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.first;
  return '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';
}

// ---------------------------------------------------------------------------
// Notification payloads
// ---------------------------------------------------------------------------

/// Builds the payload JSON string for both kinds of notification.
///
/// Individual: `{kind: 'project', projectIds: [id]}` — tap opens the
/// project. Digest: `{kind: 'digest', projectIds: [..all..]}` — tap returns
/// home.
String encodePayload({required String kind, required List<String> projectIds}) {
  return jsonEncode({'kind': kind, 'projectIds': projectIds});
}

/// `📌 {title} ({percent}%)`
String individualTitle(ProjectModel project) {
  final percent = (project.progress * 100).round();
  return '📌 ${project.title} ($percent%)';
}

/// `{remainingTasks} tasks remaining • Due {formattedEndDate}`
String individualBody(ProjectModel project) {
  final remaining = project.tasks.where((t) => t.isCompleted != true).length;
  return '$remaining tasks remaining • Due ${project.formattedEndDate}';
}

/// `Flowi • {n} Active Projects Today`
String digestTitle(int count) => 'Flowi • $count Active Projects Today';

/// `{title1} ({p}%), {title2} ({p}%) and {k} more need attention.`
///
/// Names at most the first 2 projects; the rest is counted. With exactly
/// two projects each is named exactly once.
String digestBody(List<ProjectModel> projects) {
  if (projects.isEmpty) return 'Projects need attention.';
  if (projects.length == 1) {
    return '${_nameWithProgress(projects.first)} needs attention.';
  }
  if (projects.length == 2) {
    return '${_nameWithProgress(projects[0])} and '
        '${_nameWithProgress(projects[1])} need attention.';
  }
  final named = projects.take(2).map(_nameWithProgress).join(', ');
  final more = projects.length - 2;
  return '$named and $more more need attention.';
}

String _nameWithProgress(ProjectModel project) {
  final percent = (project.progress * 100).round();
  return '${project.title} ($percent%)';
}
