/// Local check-in reminder notifications (Android only).
///
/// One-shot scheduling only: [resync] cancels everything and re-registers
/// the upcoming fire times for the rolling window (≤ 7 days, capped at 50
/// pending notifications). The service is called on app start and after
/// every reminder/project mutation, which keeps the schedule self-healing —
/// no OS-level repeat alarms are needed.
///
/// All scheduling errors are swallowed and logged: a broken reminder system
/// must never take the app UI down. Runtime permission is NEVER requested
/// at init — see [NotificationService.requestPermissions].
library;

import 'dart:convert';
import 'dart:math' as math;

import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/persistence/project_store.dart';
import 'package:flowi/core/services/reminder_resolver.dart';
import 'package:flowi/core/utils/app_router.dart';
import 'package:flowi/core/utils/debug_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Android notification channel used by every Flowi reminder.
const String kReminderChannelId = 'flowi_project_reminders';

/// Android group key so same-minute notifications bundle cleanly.
const String kReminderGroupKey = 'flowi_project_reminders';

/// Fixed base for deterministic digest notification ids.
///
/// Notification ids must be stable across resyncs of identical state, so
/// both generators below are pure hashes of state — never of wall clock:
///  * individual = projectId.hashCode ^ (hh * 60 + mm) ^ dayIndex
///    (dayIndex counted from today, so "Mon 09:00" and "Tue 09:00" differ),
///  * digest     = 0x1D6 ^ (hh * 60 + mm)          (fire-date independent;
///    digests are scheduled right after cancelAll() so an id reused across
///    days is always replaced, never left stale).
const int _digestIdBase = 0x1D6;

/// Cap on pending notifications in the rolling window.
const int _maxPending = 50;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Whether the plugin and timezones are ready. Guard agains double-init.
  bool _ready = false;

  /// True once [initAndSync] has registered the plugin. Callers (cubits,
  /// UI) can use this to avoid triggering a resync before initialization.
  bool get isReady => _ready;

  /// Initializes the plugin once and brings the schedule up to date.
  ///
  /// Called once from `main()` after [ProjectStore.open]. Never requests
  /// runtime permissions — the permission prompt is tied to the settings
  /// toggle instead.
  Future<void> initAndSync() async {
    if (_ready) {
      await resync();
      return;
    }
    try {
      await _initTimezones();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(android: androidInit),
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      // Eagerly create the notification channel. Scheduling normally
      // creates it implicitly from the NotificationDetails, but a missing
      // channel makes notification display fail silently — never rely on
      // that here.
      final androidImplementation = _resolveAndroid();
      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          kReminderChannelId,
          'Project Reminders',
          description: 'Reminds you to check in on active projects.',
          importance: Importance.high,
          playSound: true,
        ),
      );

      _ready = true;
      await resync();
    } catch (error, stackTrace) {
      _logFailure('initAndSync', error, stackTrace);
    }
  }

  /// Re-reads all state and rebuilds the schedule.
  ///
  /// Intentionally dependency-free (no cubits): it reads the global config
  /// from the settings box and the projects from [ProjectStore], so it can
  /// be called from main, from cubits, and from the settings sheet.
  Future<void> resync() async {
    try {
      await _plugin.cancelAll();

      final global = GlobalReminderConfig.load();
      if (!global.enabled) {
        DebugLogger.log('Reminders disabled — schedule cleared.',
            tag: 'NotificationService');
        return;
      }

      final projects = ProjectStore.readAll();
      final fireTimes = generateFireTimes(projects: projects, global: global);

      // Only still-future fires, oldest first; drop anything beyond the cap.
      final now = DateTime.now();
      final fires = fireTimes.entries
          .where((entry) => entry.key.isAfter(now))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final capped = fires.take(_maxPending);

      var scheduled = 0;

      for (final entry in capped) {
        final fire = entry.key;
        final firingProjects = entry.value;
        final details =
            _notificationDetails(isDigest: firingProjects.length > 1);

        if (firingProjects.length == 1) {
          final project = firingProjects.first;
          await _plugin.zonedSchedule(
            id: _individualId(project.id, fire),
            title: individualTitle(project),
            body: individualBody(project),
            payload:
                encodePayload(kind: 'project', projectIds: [project.id]),
            scheduledDate: _asTz(fire),
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        } else {
          await _plugin.zonedSchedule(
            id: _digestId(fire),
            title: digestTitle(firingProjects.length),
            body: digestBody(firingProjects),
            payload: encodePayload(
              kind: 'digest',
              projectIds: [for (final p in firingProjects) p.id],
            ),
            scheduledDate: _asTz(fire),
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        }
        scheduled++;
      }
      final next = capped.isEmpty ? 'none' : capped.first.key.toString();

      // Diagnostics: a granted permission can be revoked later, and the OS
      // can also silently drop alarms (e.g. after a force-stop). Log both.
      final impl = _resolveAndroid();
      final notificationsOn = await impl?.areNotificationsEnabled() ?? false;
      final pendingAfterSync =
          (await impl?.pendingNotificationRequests())?.length ?? -1;

      DebugLogger.log(
        'Scheduled $scheduled notification(s) across ${capped.length} fire '
        'time(s). Rolling window: one fire per project slot per day for the '
        'next 7 days, capped at $_maxPending. Next fire: $next. '
        'OS notifications enabled: $notificationsOn · pending after sync: '
        '$pendingAfterSync.',
        tag: 'NotificationService',
      );
    } catch (error, stackTrace) {
      _logFailure('resync', error, stackTrace);
    }
  }

  /// Requests the runtime notification permission (Android 13+).
  ///
  /// Returns true when notifications are allowed afterwards. Called ONLY
  /// from the settings toggle — never at boot.
  Future<bool> requestPermissions() async {
    try {
      final granted = await
          _resolveAndroid()?.requestNotificationsPermission();
      return granted ?? true;
    } catch (error, stackTrace) {
      _logFailure('requestPermissions', error, stackTrace);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  AndroidFlutterLocalNotificationsPlugin? _resolveAndroid() {
    try {
      return _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
    } catch (error) {
      _logFailure('resolveAndroid', error, null);
      return null;
    }
  }

  NotificationDetails _notificationDetails({required bool isDigest}) {
    final android = AndroidNotificationDetails(
      kReminderChannelId,
      'Project Reminders',
      channelDescription: 'Reminds you to check in on active projects.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      groupKey: kReminderGroupKey,
      // The digest acts as the Android group summary; individuals do not.
      setAsGroupSummary: isDigest,
    );
    return NotificationDetails(android: android);
  }

  /// Initializes timezones and picks the device's local zone.
  ///
  /// Android reports names like 'Africa/Cairo' or long English names
  /// ('Egypt Standard Time'). Try the reported name first (normalized to
  /// the tz database convention), then the database lookup, and finally
  /// fall back to Cairo so scheduling always has a usable local zone.
  Future<void> _initTimezones() async {
    tzdata.initializeTimeZones();

    final reported = DateTime.now().timeZoneName.trim();
    final candidates = <String>[
      reported.replaceAll(' ', '_'),
      reported,
    ];
    for (final candidate in candidates) {
      try {
        final location = tz.getLocation(candidate);
        tz.setLocalLocation(location);
        DebugLogger.log('Local timezone: $candidate',
            tag: 'NotificationService');
        return;
      } catch (_) {
        // Try the next candidate.
      }
    }
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    DebugLogger.log('Local timezone fallback: Africa/Cairo',
        tag: 'NotificationService');
  }

  /// Deterministic id for a single-project notification.
  int _individualId(String projectId, DateTime fire) {
    final dayIndex = DateTime(fire.year, fire.month, fire.day)
        .difference(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ))
        .inDays;
    return projectId.hashCode ^
        (fire.hour * 60 + fire.minute) ^
        math.max(dayIndex, 0);
  }

  /// Deterministic id for a digest notification at [fire].
  int _digestId(DateTime fire) => _digestIdBase ^ (fire.hour * 60 + fire.minute);

  tz.TZDateTime _asTz(DateTime fire) => tz.TZDateTime.from(fire, tz.local);

  /// Routes a notification tap.
  ///
  /// kind == 'project' → edit-project route for that id (fetch the project
  /// first; if it was deleted meanwhile, go home silently).
  /// kind == 'digest'  → home.
  void _handleNotificationResponse(NotificationResponse response) {
    try {
      final payload = response.payload;
      if (payload == null || payload.isEmpty) {
        AppRouter.router.push(AppRouter.kLayOut);
        return;
      }
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final kind = map['kind'];
      final ids = (map['projectIds'] as List?)?.cast<String>() ?? const [];

      if (kind == 'project' && ids.isNotEmpty) {
        final targetId = ids.first;
        ProjectModel? project;
        for (final p in ProjectStore.readAll()) {
          if (p.id == targetId) {
            project = p;
            break;
          }
        }
        if (project != null) {
          AppRouter.router.push(AppRouter.kEditProject, extra: project);
        } else {
          // Deleted since it fired — fall back home silently.
          AppRouter.router.push(AppRouter.kLayOut);
        }
        return;
      }
      AppRouter.router.push(AppRouter.kLayOut);
    } catch (error, stackTrace) {
      _logFailure('handleNotificationResponse', error, stackTrace);
      AppRouter.router.push(AppRouter.kLayOut);
    }
  }

  void _logFailure(String operation, Object error, StackTrace? stackTrace) {
    DebugLogger.logError('Notification $operation failed: $error',
        context: 'NotificationService', stackTrace: stackTrace);
  }
}
