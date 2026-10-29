/// Shared reminder schedule editor used by both the Settings bottom sheet
/// (global config) and the per-project "Custom" expansion.
///
/// It owns NO state and NO persistence: every interaction is handed back
/// through the callbacks and the caller commits (cubit → store → resync).
library;

import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Day chip labels, displayed in the user-visible order
/// Sunday → Saturday ('S M T W T F S').
const List<(int, String)> _kDayChips = [
  (7, 'S'), // Sunday
  (1, 'M'),
  (2, 'T'),
  (3, 'W'),
  (4, 'T'),
  (5, 'F'),
  (6, 'S'), // Saturday
];

class ReminderScheduleEditor extends StatelessWidget {
  const ReminderScheduleEditor({
    super.key,
    required this.cadence,
    required this.dailySlots,
    required this.weeklyWeekdays,
    required this.weeklyTime,
    required this.onCadenceChanged,
    required this.onDailySlotsChanged,
    required this.onWeeklyDaysChanged,
    required this.onWeeklyTimeChanged,
  });

  final ReminderCadence cadence;

  /// 'HH:mm' entries, 0..3.
  final List<String> dailySlots;

  /// ISO weekdays (1=Mon .. 7=Sun).
  final List<int> weeklyWeekdays;

  /// 'HH:mm'.
  final String weeklyTime;

  final ValueChanged<ReminderCadence> onCadenceChanged;
  final ValueChanged<List<String>> onDailySlotsChanged;
  final ValueChanged<List<int>> onWeeklyDaysChanged;
  final ValueChanged<String> onWeeklyTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        _CadencePill(
          cadence: cadence,
          onCadenceChanged: onCadenceChanged,
        ),
        const SizedBox(height: 16),
        if (cadence == ReminderCadence.daily)
          _DailyEditor(
            slots: dailySlots,
            onSlotsChanged: (slots) =>
                onDailySlotsChanged(List<String>.from(slots)),
          )
        else ...[
          _DayChipsRow(
            selected: weeklyWeekdays.toSet(),
            onSelectionChanged: onWeeklyDaysChanged,
          ),
          const SizedBox(height: 12),
          _TimeRow(
            label: 'Reminder time',
            time: weeklyTime,
            onChanged: onWeeklyTimeChanged,
          ),
        ],
      ],
    );
  }
}

/// Defaults used when the user adds another daily slot.
const List<String> kDefaultReminderSlots = ['09:00', '14:00', '20:00'];

// ---------------------------------------------------------------------------
// Cadence pill
// ---------------------------------------------------------------------------

class _CadencePill extends StatelessWidget {
  const _CadencePill({
    required this.cadence,
    required this.onCadenceChanged,
  });

  final ReminderCadence cadence;
  final ValueChanged<ReminderCadence> onCadenceChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: 'Daily',
            selected: cadence == ReminderCadence.daily,
            onTap: () => onCadenceChanged(ReminderCadence.daily),
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PillButton(
            label: 'Weekly',
            selected: cadence == ReminderCadence.weekly,
            onTap: () => onCadenceChanged(ReminderCadence.weekly),
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(19),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.textStyle14.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Daily editor: count chips + slot rows + "Add time"
// ---------------------------------------------------------------------------

class _DailyEditor extends StatelessWidget {
  const _DailyEditor({
    required this.slots,
    required this.onSlotsChanged,
  });

  final List<String> slots;
  final ValueChanged<List<String>> onSlotsChanged;

  void _setCount(int count) {
    if (count == slots.length) return;
    final updated = List<String>.from(slots);
    while (updated.length < count && updated.length < 3) {
      final next = kDefaultReminderSlots.firstWhere(
        (candidate) => !updated.contains(candidate),
        orElse: () => '${updated.length + 8}:00',
      );
      updated.add(next);
    }
    while (updated.length > count) {
      updated.removeLast();
    }
    onSlotsChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 10,
          children: [
            for (final count in [1, 2, 3])
              _PillButton(
                label: '$count x/day',
                selected: slots.length == count,
                onTap: () => _setCount(count),
                colorScheme: colorScheme,
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < slots.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TimeRow(
              label: 'Time ${i + 1}',
              time: slots[i],
              onChanged: (pickedTime) {
                final updated = List<String>.from(slots);
                updated[i] = pickedTime;
                onSlotsChanged(updated);
              },
            ),
          ),
        if (slots.length < 3)
          TextButton.icon(
            onPressed: () => _setCount(slots.length + 1),
            icon: const Icon(Iconsax.add_circle, size: 20),
            label: const Text('Add time'),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly day chips
// ---------------------------------------------------------------------------

class _DayChipsRow extends StatelessWidget {
  const _DayChipsRow({
    required this.selected,
    required this.onSelectionChanged,
  });

  final Set<int> selected;
  final ValueChanged<List<int>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      children: [
        for (final (isoValue, label) in _kDayChips)
          FilterChip(
            label: Text(label),
            selected: selected.contains(isoValue),
            onSelected: (value) {
              final next = Set<int>.from(selected);
              if (value) {
                next.add(isoValue);
              } else {
                next.remove(isoValue);
              }
              onSelectionChanged(next.whereType<int>().toList());
            },
            labelStyle: AppTextStyles.textStyle14.copyWith(
              fontWeight: FontWeight.w600,
              color: selected.contains(isoValue)
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
            ),
            selectedColor: colorScheme.primary,
            checkmarkColor: colorScheme.onPrimary,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared time row (a compact CustomDateTimeButton)
// ---------------------------------------------------------------------------

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.time,
    required this.onChanged,
  });

  final String label;
  final String time;
  final ValueChanged<String> onChanged;

  Future<void> _pick(BuildContext context) async {
    final current = time.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(current.first) ?? 9,
        minute:
            current.length > 1 ? int.tryParse(current[1]) ?? 0 : 0,
      ),
    );
    if (picked == null) return;
    final hhmm =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    onChanged(hhmm);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      tileColor: colorScheme.surface,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Iconsax.clock,
          color: colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.textStyle14.copyWith(
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        time,
        style: AppTextStyles.textStyle16.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Iconsax.arrow_down_1),
      onTap: () => _pick(context),
    );
  }
}
