# Project Check-in Reminders — Plan

Status: planned (v1 scope locked Oct 28 2026)

## Decisions (locked)
| Decision | Choice |
|---|---|
| Trigger | Check-in nudge, fixed schedule (no idle/deadline logic in v1) |
| Scope | Global defaults + per-project override (`Default` / `Custom` / `Off`) |
| Cadence | **Daily** (1x / 2x / 3x per day) and **Weekly** (weekday chips + time) only |
| Grouping | **Digest**: one summary notification per global slot when multiple projects are in scope; individual notifications only for projects with a **Custom** schedule |
| Storage | New Hive fields on `ProjectModel` (fields 9–11) + global config in settings box, per `ProjectStore` migration convention |

## Feature summary
Notify the user to check in on his projects.
- Global (Settings): master switch, scope (All active / Custom projects only), cadence (Daily 1–3 times/day with editable time chips, or Weekly with day-of-week multi-select + time).
- Per project (Add/Edit Project, below End Date): `Default` / `Custom` (inline cadence chips) / `Off`.
- Auto-stop: `status == TaskStatus.completed` projects never get scheduled. Optional later: also stop after `endDate` passed.

## Data model

### Global config — settings box (`Constants.kSettingsBox`)
```dart
// Key: kGlobalReminderKey; untyped map or serialized object
class GlobalReminderConfig {
  bool enabled;
  ReminderScope scope;          // all | selected
  Set<String> selectedIds;      // only when scope == selected
  ReminderCadence cadence;      // daily | weekly
  List<TimeSlot> dailySlots;    // up to 3 (e.g. 09:00, 14:00, 20:00)
  List<int> weekdays;           // ISO 1..7 Mon..Sun (weekly)
  TimeOfDay weeklyTime;         // single time for weekly
}
```

### Per project — `ProjectModel` (typeId 0)
```dart
@HiveField(9) String? reminderMode;          // 'default' | 'custom' | 'off'
@HiveField(10) List<String>? customSlots;    // ['10:00','18:00'] (daily slots, max 3)
@HiveField(11) List<int>? customWeekdays;    // null = daily; [1,3,5] = weekly Mon/Wed/Fri
```
- `reminderMode` kept nullable on disk; constructor default `'default'`; semantic access via getters.
- Old records deserialize with null fields → handled by the v2 migration rewrite (see below).

### Migration — follow `ProjectStore` convention
1. Bump `ProjectStore.schemaVersion` → `2`.
2. In `migration(...)`: rewrite every record so fields 9–11 persist for pre-existing projects.
3. Cover with tests in `test/core/persistence/`.
4. `hive_generator` is blocked (analyzer conflict, see pubspec.yaml) → **hand-update `project_model.g.dart`** to include the three new `HiveField` descriptors (additive change, plus `buildRunner` note stays).
5. `ProjectModel.copyWith` must carry the new fields (reminder changed → bump `lastModified` is fine/existing behavior).

## Scheduling — Rolling Window Coordinator
Platform limits: iOS caps pending local notifications at **64**; Android throttles excessive alarms. Therefore **no infinite repeating alarms per project**.

`lib/core/services/notification_service.dart`:
- `flutter_local_notifications` + `timezone`.
- `resync(allProjects, globalConfig)` — called from `main` (app start), `ProjectCubit.addProject/editProject/deleteProject`, and reminder settings changes. Cancels all stale alarms, schedules **the next 7 days** of upcoming slots (cap ~50 pending).
- Deterministic notification IDs: `project.id.hashCode ^ slotIndex` (digest → fixed digest ID per slot).
- Pure Dart slot calculation (given cadence + weekday/slots → next fire DateTimes) extracted so it's unit-testable **without platform channels**.
- Precision: `AndroidScheduleMode.inexactAllowWhileIdle` — reminders arriving within minutes of target time is fine here; avoids `SCHEDULE_EXACT_ALARM` Play Store policy risk (exact-alarm permission is restricted to calendar/alarm-clock apps for apps targeting newer Play policies).
- Digest logic: for each global slot fire time, count in-scope active projects → 0: nothing; 1–2: individual; 3+: single digest? — **No (locked decision)**: global slots always fire ONE digest when scope = all/selected with >1 project; individual only for Custom-schedule projects (they have private slots anyway). A Custom project whose slot coincides with a global slot still fires individually.
- Payload: JSON string `{ kind: 'project'|'digest', projectId?: String, projectIds?: [...] }` → tap routes via `go_router` (`onDidReceiveNotificationResponse`), project → Edit Project, digest → Home.

## Notification content
- **Single project:**
  - Title: `📌 {title} ({progress}% done)`
  - Body: `{tasksRemaining} tasks remaining • Due {formattedEndDate}`
  - Tap: deep-link to that project.
- **Digest (global slots):**
  - Title: `Flowi • {n} Active Projects Today`
  - Body: `{title1} ({p1}%), {title2} ({p2}%), and {k} more need attention.`
  - Tap: opens Home.
- Reuse `ProjectModel.progress` getter and `formattedEndDate` — both exist.

## Permissions / manifest
- Android 13+: `POST_NOTIFICATIONS` runtime prompt — requested **only when user toggles Reminders ON** (never on cold boot). Denied → silent fallback + in-app hint.
- `RECEIVE_BOOT_COMPLETED` + plugin's `ScheduledNotificationBootReceiver` → alarms survive reboot. Rolling-window resync on app start is the self-healing net.
- iOS: request `.alert/.sound/.badge` on first enable (64 pending cap handled by rolling window).

## UI

### Settings (`SettingsViewBody`, after `DarkThemeToggle`): `NotificationSettingsTile` → bottom sheet/screen
```
┌─────────────────────────────────────────────────────┐
│ 🔔 Project Reminders                         [ ON ] │
├─────────────────────────────────────────────────────┤
│ Notify me for                                       │
│ (•) All active projects   ( ) Custom projects only  │
│                                                     │
│ Frequency                                           │
│ [  Daily  ]   [  Weekly  ]      <-- Segmented pill  │
│                                                     │
│ If Daily:                                           │
│ Times per day:  (•) 1x    ( ) 2x    ( ) 3x          │
│ At:  [ 09:00 AM ]  [ 02:00 PM ]  [ + Add time ]     │
│                                                     │
│ If Weekly:                                          │
│ Days:  (S)  [M]  (T)  [W]  (T)  [F]  (S)  (3x/wk)   │
│ At:    [ 09:00 AM ]                                 │
└─────────────────────────────────────────────────────┘
```
Rationale: time slots + weekday chips answer both "how many times" and "when" explicitly — no raw counts left for the app to interpret.

### Add/Edit Project (`AddProjectViewBody` / `EditProjectViewBody`, below End Date): `ProjectReminderSection`
```
┌─────────────────────────────────────────────────────┐
│ 🔔 Reminder        [ Default ▾ ] (Default/Custom/Off)│
│    (Custom expands smoothly inline:)                │
│    [ Daily ]  [ Weekly ]                            │
│    Times: [ 10:00 AM ] [ 06:00 PM ]  (+ Add)        │
└─────────────────────────────────────────────────────┘
```

## Architecture & wiring
```
lib/core/services/notification_service.dart     (plugin init, permissions, resync)
lib/core/models/reminder_config.dart            (global config model + enums, pure)
lib/features/notifications/...                  (optional; can stay lean under core
                                                 for v1 — scheduler is a service, not a UI feature)
```
- Cubit owners of truth: `SettingCubit` (global config), `ProjectCubit` (per-project fields).
- `resync()` hooks: on `submitForm()` success (line ~234 `ProjectCubit`), `deleteProject()` success, and every global config mutation.
- `main.dart`: after `ProjectStore.open()` → `await NotificationService.instance.init() + resync()`.

## Implementation phases
1. **Phase 1 — Domain & Storage:** `ReminderConfig` model, `ProjectModel` fields 9–11 + hand-edited `.g.dart`, `schemaVersion` 2 + migration rewrite + tests in `test/core/persistence/`.
2. **Phase 2 — Notification Engine:** add `flutter_local_notifications` + `timezone`; pure slot-calc unit tests (no platform channels); rolling 7-day `resync()`; Android manifest additions; tap deep-link wiring.
3. **Phase 3 — Global UI:** `NotificationSettingsTile` + bottom sheet (scope, Daily x slots, Weekly day chips) wired to `SettingCubit` → `resync()`.
4. **Phase 4 — Per-project UI:** `ProjectReminderSection` in both project forms, wired to `ProjectCubit` → `resync()`; widget tests follow `test/widgets/` harness (`fakes.dart`).

## v2 candidates (out of scope)
- Idle-based reminders ("no activity for N days" via `lastModified`).
- Deadline-driven alerts (approaching `endDate` / overdue).
- Per-project bell quick-toggle on home cards.
- "Every N days" interval cadence (dropped from v1 by decision).
