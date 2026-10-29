/// Global (app-wide) check-in reminder configuration.
///
/// Pure Dart — no Flutter imports — so it can be unit tested and used from
/// any layer. Persisted as a `Map<String, dynamic>` in the settings box under
/// [Constants.kGlobalReminderKey].
///
/// All parsing is defensive: a corrupt or half-missing record yields the
/// defaults instead of crashing the app at boot.

import 'package:flowi/core/utils/constants.dart';
import 'package:hive/hive.dart';

enum ReminderScope { all, selected }

enum ReminderCadence { daily, weekly }

class GlobalReminderConfig {
  /// Master switch. When false nothing is scheduled, per-project settings
  /// included.
  final bool enabled;

  /// Whether reminders apply to [ReminderScope.all] active projects or only
  /// the ones the user picked.
  final ReminderScope scope;

  /// Project ids used when [scope] == [ReminderScope.selected].
  final Set<String> selectedIds;

  /// Cadence of the global reminder.
  final ReminderCadence cadence;

  /// Daily times as 'HH:mm' strings, at most 3 entries.
  final List<String> dailySlots;

  /// ISO weekdays (1=Mon .. 7=Sun) for the weekly cadence.
  final List<int> weeklyWeekdays;

  /// The single weekly time as 'HH:mm'.
  final String weeklyTime;

  const GlobalReminderConfig({
    this.enabled = false,
    this.scope = ReminderScope.all,
    this.selectedIds = const {},
    this.cadence = ReminderCadence.daily,
    this.dailySlots = const [],
    this.weeklyWeekdays = const [],
    this.weeklyTime = '09:00',
  });

  /// Off-by-default instance.
  static const GlobalReminderConfig defaults = GlobalReminderConfig();

  GlobalReminderConfig copyWith({
    bool? enabled,
    ReminderScope? scope,
    Set<String>? selectedIds,
    ReminderCadence? cadence,
    List<String>? dailySlots,
    List<int>? weeklyWeekdays,
    String? weeklyTime,
  }) {
    return GlobalReminderConfig(
      enabled: enabled ?? this.enabled,
      scope: scope ?? this.scope,
      selectedIds: selectedIds ?? this.selectedIds,
      cadence: cadence ?? this.cadence,
      dailySlots: dailySlots ?? this.dailySlots,
      weeklyWeekdays: weeklyWeekdays ?? this.weeklyWeekdays,
      weeklyTime: weeklyTime ?? this.weeklyTime,
    );
  }

  /// Tolerant deserializer: any missing, mistyped, or malformed value falls
  /// back to the default. Never throws.
  factory GlobalReminderConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;

    return GlobalReminderConfig(
      enabled: map['enabled'] == true,
      scope: map['scope'] == 'selected'
          ? ReminderScope.selected
          : ReminderScope.all,
      selectedIds: (map['selectedIds'] as List?)?.whereType<String>().toSet() ??
          const {},
      cadence: map['cadence'] == 'weekly'
          ? ReminderCadence.weekly
          : ReminderCadence.daily,
      dailySlots: _parseSlots(map['dailySlots']),
      weeklyWeekdays: (map['weeklyWeekdays'] as List?)
              ?.whereType<num>()
              .map((n) => n.toInt())
              .where((d) => d >= 1 && d <= 7)
              .toList() ??
          const <int>[],
      weeklyTime: _parseTime(map['weeklyTime']) ?? '09:00',
    );
  }

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
        'scope': scope.name,
        'selectedIds': selectedIds.toList(),
        'cadence': cadence.name,
        'dailySlots': dailySlots,
        'weeklyWeekdays': weeklyWeekdays,
        'weeklyTime': weeklyTime,
      };

  /// Reads the config from the settings box. Returns the off-by-default
  /// config when nothing is stored or the record cannot be interpreted.
  static GlobalReminderConfig load() {
    try {
      if (!Hive.isBoxOpen(Constants.kSettingsBox)) {
        return defaults;
      }
      final raw = Hive.box(Constants.kSettingsBox)
          .get(Constants.kGlobalReminderKey) as Map?;
      return GlobalReminderConfig.fromMap(raw?.cast<String, dynamic>());
    } catch (_) {
      return defaults;
    }
  }

  /// Persists the config to the settings box.
  Future<void> save() {
    final box = Hive.box(Constants.kSettingsBox);
    return box.put(Constants.kGlobalReminderKey, toMap());
  }

  /// Parses up to 3 'HH:mm' slot strings, dropping malformed ones.
  static List<String> _parseSlots(Object? rawSlots) {
    if (rawSlots is! List) return const [];
    return rawSlots
        .whereType<String>()
        .map((slot) => _parseTime(slot))
        .whereType<String>()
        .take(3)
        .toList();
  }

  /// Returns a normalized 'HH:mm' string, or null when [raw] is not a
  /// parseable time.
  static String? _parseTime(Object? raw) {
    if (raw is! String) return null;
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw.trim());
    if (match == null) return null;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
