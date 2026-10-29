/// Settings row for global project check-in reminders.
///
/// Matches the [DarkThemeToggle] row style. Tapping opens a bottom sheet in
/// which every change commits immediately to [SettingCubit] (no save
/// button); each commit re-aligns the schedule via a service resync.
///
/// The runtime notification permission is requested ONLY when the user
/// turns the master switch ON. If it is denied the switch stays off and a
/// snackbar explains the outcome — never requested at boot.

import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/persistence/project_store.dart';
import 'package:flowi/core/services/notification_service.dart';
import 'package:flowi/core/utils/app_text_styles.dart';
import 'package:flowi/core/widgets/reminder_schedule_editor.dart';
import 'package:flowi/core/utils/debug_logger.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class NotificationSettingsTile extends StatelessWidget {
  const NotificationSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = context.watch<SettingCubit>().reminderConfig;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return ListTile(
          shape: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurface),
            borderRadius: BorderRadius.circular(19),
          ),
          tileColor: colorScheme.surface,
          leading: Icon(
            Iconsax.notification_1,
            color: colorScheme.primary,
          ),
          title: Text(
            'Project Reminders',
            style: TextStyle(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            config.enabled
                ? 'Check-in reminders are on'
                : 'Check-in reminders are off',
          ),
          trailing: Switch(
            value: config.enabled,
            activeThumbColor: colorScheme.primary,
            onChanged: (value) => _onMasterToggle(context, value),
          ),
          // Tapping the row opens the full configuration sheet; the switch
          // itself goes through the permission flow.
          onTap: () => showReminderSettingsSheet(context),
        );
      },
    );
  }

  Future<void> _onMasterToggle(BuildContext context, bool value) async {
    if (!value) {
      context.read<SettingCubit>().updateReminderConfig(
          context.read<SettingCubit>().reminderConfig.copyWith(enabled: false));
      return;
    }
    // Ask only here — the user explicitly opted in.
    final granted = await NotificationService.instance.requestPermissions();
    if (!granted) {
      // Switch stays off (cubit was never updated).
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notification permission denied — reminders stay off. '
              'Allow notifications for Flowi in system settings.',
            ),
          ),
        );
      }
      return;
    }
    if (context.mounted) {
      context.read<SettingCubit>().updateReminderConfig(
          context.read<SettingCubit>().reminderConfig.copyWith(enabled: true));
    }
  }
}

/// Opens the full configuration sheet for global reminders.
void showReminderSettingsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: const _ReminderConfigSheet(),
      );
    },
  );
}

/// The sheet body: master switch, scope, cadence and schedule editor.
///
/// Stateless on purpose: the sheet re-reads the live config from
/// [SettingCubit] on every emitted state, so each commit rerenders here.
class _ReminderConfigSheet extends StatelessWidget {
  const _ReminderConfigSheet();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = context.watch<SettingCubit>().reminderConfig;

    void commit(GlobalReminderConfig updated) {
      context.read<SettingCubit>().updateReminderConfig(updated);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.notification_status,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(
              'Project Reminders',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable reminders'),
          subtitle: const Text('Remind me to check in on my projects'),
          value: config.enabled,
          activeThumbColor: colorScheme.primary,
          onChanged: (value) async {
            if (!value) {
              commit(config.copyWith(enabled: false));
              return;
            }
            final granted =
                await NotificationService.instance.requestPermissions();
            DebugLogger.log('Reminder permission granted: $granted',
                tag: 'NotificationSettings');
            if (!granted) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Notification permission denied — reminders stay off. '
                      'Allow notifications for Flowi in system settings.',
                    ),
                  ),
                );
              }
              return;
            }
            if (context.mounted) {
              commit(config.copyWith(enabled: true));
            }
          },
        ),
        const Divider(),
        const Text('Applies to'),
        RadioGroup<ReminderScope>(
          groupValue: config.scope,
          onChanged: (scope) {
            if (scope != null) {
              commit(config.copyWith(scope: scope));
            }
          },
          child: Column(
            children: [
              RadioListTile<ReminderScope>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('All active projects'),
                value: ReminderScope.all,
              ),
              RadioListTile<ReminderScope>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Custom projects only'),
                value: ReminderScope.selected,
              ),
            ],
          ),
        ),
        if (config.scope == ReminderScope.selected) ...[
          _ProjectSelectionList(
            selectedIds: config.selectedIds,
            onSelectionChanged: (ids) =>
                commit(config.copyWith(selectedIds: ids)),
          ),
          const Divider(),
        ],
        const SizedBox(height: 8),
        const Text('Frequency'),
        const SizedBox(height: 8),
        ReminderScheduleEditor(
          cadence: config.cadence,
          dailySlots: config.dailySlots,
          weeklyWeekdays: config.weeklyWeekdays,
          weeklyTime: config.weeklyTime,
          onCadenceChanged: (cadence) =>
              commit(config.copyWith(cadence: cadence)),
          onDailySlotsChanged: (slots) =>
              commit(config.copyWith(dailySlots: slots)),
          onWeeklyDaysChanged: (days) =>
              commit(config.copyWith(weeklyWeekdays: days)),
          onWeeklyTimeChanged: (time) =>
              commit(config.copyWith(weeklyTime: time)),
        ),
      ],
    );
  }
}

/// Multi-select checkboxes for scope == selected, plus an empty-state hint.
class _ProjectSelectionList extends StatelessWidget {
  const _ProjectSelectionList({
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final candidates = ProjectStore.readAll().where(
      (project) => project.status != TaskStatus.completed,
    );

    if (candidates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No active projects yet — create one to pick it for reminders.',
          style: AppTextStyles.textStyle12(context),
        ),
      );
    }

    return Column(
      children: [
        for (final project in candidates)
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              project.title,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            // A project with its own custom schedule ignores the global
            // config entirely — tell the user why checking it changes
            // nothing for that project.
            subtitle: project.reminderMode == 'custom'
                ? Text(
                    'Has its own custom schedule — it will use that instead',
                    style: AppTextStyles.textStyle12(context),
                  )
                : null,
            value: selectedIds.contains(project.id),
            activeColor: colorScheme.primary,
            onChanged: (checked) {
              final next = Set<String>.from(selectedIds);
              if (checked == true) {
                next.add(project.id);
              } else {
                next.remove(project.id);
              }
              onSelectionChanged(next);
            },
          ),
      ],
    );
  }
}
