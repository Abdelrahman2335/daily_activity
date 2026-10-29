/// Per-project check-in reminder card, placed below the start/end date
/// fields in both the add and edit project forms.
///
/// Row layout: bell icon, title, a [Default / Custom / Off] dropdown.
/// 'Custom' expands inline (animated cross fade) into the shared
/// [ReminderScheduleEditor] plus a live status line computed through the
/// same resolver as the scheduler. 'Default' shows what the global config
/// will produce for this project.
library;

import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/services/reminder_resolver.dart';
import 'package:flowi/core/utils/app_text_styles.dart';
import 'package:flowi/core/widgets/reminder_schedule_editor.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ProjectReminderSection extends StatelessWidget {
  const ProjectReminderSection({super.key, required this.formState});

  final ProjectFormState formState;

  static const List<String> _kModes = ['Default', 'Custom', 'Off'];

  /// Live global config while a [SettingCubit] is in scope (the normal app
  /// tree); falls back to reading the settings box directly otherwise
  /// (widget tests pump the form without the settings bloc).
  GlobalReminderConfig _readGlobalConfig(BuildContext context) {
    try {
      return context.watch<SettingCubit>().reminderConfig;
    } catch (_) {
      return GlobalReminderConfig.load();
    }
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'custom':
        return 'Custom';
      case 'off':
        return 'Off';
      default:
        return 'Default';
    }
  }

  String _modeValue(String label) {
    switch (label) {
      case 'Custom':
        return 'custom';
      case 'Off':
        return 'off';
      default:
        return 'default';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<ProjectCubit>();
    final global = _readGlobalConfig(context);
    final mode = formState.reminderMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.notification_1,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Project Reminder',
                  style: AppTextStyles.textStyle14.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _modeLabel(mode),
                icon: const Icon(Iconsax.arrow_down_1),
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(19),
                style: AppTextStyles.textStyle14.copyWith(
                  color: colorScheme.onSurface,
                ),
                dropdownColor: colorScheme.surface,
                onTap: () => FocusScope.of(context).unfocus(),
                onChanged: (label) {
                  if (label == null) return;
                  cubit.reminderModeChange(_modeValue(label));
                },
                items: [
                  for (final label in _kModes)
                    DropdownMenuItem(
                      value: label,
                      child: Text(label, style: AppTextStyles.textStyle14),
                    ),
                ],
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeInOut,
            crossFadeState: mode == 'custom'
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReminderScheduleEditor(
                    cadence: formState.reminderCadence,
                    dailySlots: formState.customSlots,
                    weeklyWeekdays: formState.customWeekdays,
                    weeklyTime: formState.weeklyTime,
                    onCadenceChanged: cubit.reminderCadenceChange,
                    onDailySlotsChanged: cubit.reminderDailySlotsChange,
                    onWeeklyDaysChanged: cubit.reminderWeeklyDaysChange,
                    onWeeklyTimeChanged: cubit.reminderWeeklyTimeChange,
                  ),
                  const SizedBox(height: 8),
                  _StatusLine(
                    message: _customStatusMessage(global),
                  ),
                ],
              ),
            ),
            secondChild:
                mode == 'default'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _DefaultModeSummary(
                          global: global,
                          projectId: formState.project.id,
                        ),
                      )
                    : const SizedBox(height: 0, width: 0),
          ),
        ],
      ),
    );
  }

  /// What the current custom schedule will actually produce, computed
  /// through [resolveReminder] so the UI and the scheduler share one truth.
  String _customStatusMessage(GlobalReminderConfig global) {
    final isWeekly = formState.reminderCadence == ReminderCadence.weekly;
    final effective = resolveReminder(
      status: formState.project.status,
      endDate: formState.project.endDate,
      projectId: formState.project.id,
      reminderMode: 'custom',
      // The editor keeps the weekly time separate; the resolver expects it
      // in slots[0].
      customSlots: isWeekly ? [formState.weeklyTime] : formState.customSlots,
      customWeekdays: isWeekly ? formState.customWeekdays : null,
      global: global,
    );

    if (!effective.enabled) {
      return 'Project ended — reminders stopped';
    }
    if (effective.cadence == ReminderCadence.daily &&
        effective.dailySlots.isEmpty) {
      return 'Custom schedule has no valid times — nothing will notify';
    }
    if (effective.cadence == ReminderCadence.weekly &&
        effective.weeklyWeekdays.isEmpty) {
      return 'Pick at least one weekday — nothing will notify';
    }

    var message = 'Active — ${effective.summary()}';
    if (global.enabled &&
        global.scope == ReminderScope.selected &&
        global.selectedIds.contains(formState.project.id)) {
      message += ' · overrides the global selection for this project';
    }
    return message;
  }
}

/// Shared one-liner row: info icon + small secondary text.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          Iconsax.info_circle,
          size: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.textStyle12(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// One-liner shown for the 'Default' (follow-global) mode.
class _DefaultModeSummary extends StatelessWidget {
  const _DefaultModeSummary({
    required this.global,
    required this.projectId,
  });

  final GlobalReminderConfig global;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    String message;
    if (!global.enabled) {
      message = "Follows global — reminders are currently off";
    } else if (global.scope == ReminderScope.selected &&
        !global.selectedIds.contains(projectId)) {
      message = "Not in selection — won't notify";
    } else {
      message = "Follows global: ${globalSummary(global)}";
    }

    return _StatusLine(message: message);
  }
}
