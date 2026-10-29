# Project Check-in Reminders — How It Works

Status: implemented & verified on device (Oct 28 2026). Android only.
Companion to `NOTIFICATIONS_PLAN.md` (the locked v1 plan). This document
explains the **logic**: how a reminder goes from user settings to a
notification, and how each edge case is handled.

---

## 1. The one Mental Model

Nothing repeats. There are no OS-level repeating alarms and no background
service. Instead, every time **anything relevant changes**, the app:

1. **Cancels** every pending notification (`cancelAll()`).
2. **Recomputes** the full fire-time table from current state.
3. **Schedules** only the still-future fires for a rolling window ahead.

This makes the schedule **self-healing**: the pending set is always a pure
function of (global config + projects + current time). If the app was
force-stopped, permissions revoked, or data edited while away — the next
app start rebuilds a correct schedule from scratch.

The cost is one full rebuild per mutation (two rapid rebuilds on a chip
change is normal), which is cheap: bounded at 50 `zonedSchedule` calls as
one-shot alarms.

---

## 2. Layers

| Layer | File | Responsibility |
|---|---|---|
| Config models | `lib/core/models/reminder_config.dart` | `GlobalReminderConfig` + enums; tolerant (never-throws) parsing |
| Project fields | `lib/core/models/project_model.dart` (+ `.g.dart`) | `reminderMode` / `customSlots` / `customWeekdays` (HiveFields 9–11) |
| **Resolver (pure)** | `lib/core/services/reminder_resolver.dart` | Decides *which* projects notify and *when*; builds titles/bodies/payloads. No plugin imports — deterministic and unit-testable |
| **Scheduler** | `lib/core/services/notification_service.dart` | Singleton owning the plugin: init, `resync()`, permission request, tap routing |
| Global UI | `lib/features/settings/presentation/widgets/notification_settings_tile.dart` | Settings row + bottom sheet; permission flow; every change commits immediately |
| Per-project UI | `lib/features/project/presentation/widgets/project_reminder_section.dart` | `Default / Custom / Off` card in Add/Edit Project; the Custom mode shows a live "Active — …" status line computed through the shared resolver (including "overrides the global selection for this project" when applicable) |
| Shared editor | `lib/core/widgets/reminder_schedule_editor.dart` | The Daily/Weekly cadence + time editor used by both UIs |

Data flow per mutation:

```
UI (chip/toggle/change) ─commits→ Hive (settings box / project box)
      │                                 │
      └── unawaited(resync())           │
              ↙ cancelAll() ←───────────┘ fresh read
        generateFireTimes(projects, global)
              ↙ filter: future only, sort, cap 50
        zonedSchedule(...)  →  AlarmManager (one-shot per fire)
              ↙ at fire time
        ScheduledNotificationReceiver → notification posted
```

`resync()` is deliberately **dependency-free** — it reads the settings box
and `ProjectStore` directly, so it can be called from `main()`, from either
cubit, or from a settings sheet without any cross-wiring.

---

## 3. Configuration Model

### Global (settings box, key `kGlobalReminderKey`, stored as an untyped map)

| Field | Meaning |
|---|---|
| `enabled` | Master switch. When false **nothing** is scheduled, per-project settings included. |
| `scope` | `all` (every active project) or `selected` (only `selectedIds`). |
| `cadence` | `daily` or `weekly`. |
| `dailySlots` | Up to 3 `'HH:mm'` strings (e.g. `09:00, 18:30`). |
| `weeklyWeekdays` | ISO weekdays `1..7` (Mon..Sun). |
| `weeklyTime` | Single `'HH:mm'` for the weekly cadence. |

All parsing is **defensive**: a missing, mistyped, or corrupt value falls
back to its default instead of crashing at boot. Malformed time strings are
dropped; out-of-range weekdays are filtered; more than 3 slots are cut.

### Per project (`ProjectModel`, HiveFields 9–11; old records → `null`)

| Field | Meaning |
|---|---|
| `reminderMode` | `'default'` / `'custom'` / `'off'` (null behaves as `'default'`). `custom` is **fully independent** of the global config. |
| `customSlots` | Daily: up to 3 `'HH:mm'` slots. Weekly single time kept in `customSlots[0]`. |
| `customWeekdays` | `null` ⇒ daily; non-null (e.g. `[1,3,5]`) ⇒ weekly with `customSlots[0]` as the time. |

---

## 4. Resolution Logic — "should this project notify?"

`effectiveReminder(project, global)` is a pure decision chain, evaluated
in this strict order (first match wins):

```
1. status == completed                      → none
2. end date passed (day granularity)        → none
3. reminderMode == 'off'                    → none
4. reminderMode == 'custom'
     4a. customWeekdays != null             → weekly (customSlots[0], weekdays)
     4b. otherwise                          → daily  (customSlots, clamped)
     (no global checks — custom is fully independent of the global config,
      including the master switch and a global 'selected' scope that
      happens to target this project)
5. 'default' / null
     5a. global.enabled == false            → none
     5b. scope == selected && not selected  → none
     5c. else                               → global cadence & slots
```

Key design point: **`custom` ignores the global config entirely; `default`
follows it; `off` always wins.** A project with a custom schedule keeps
firing even when reminders are off globally, and even when the global
scope = selected picks that project — the global selection simply does
not apply to it. The global config is only the default for projects on
'Default' mode.

Slots are also re-clamped at resolution time (normalized `'HH:mm'`,
deduplicated, sorted, max 3), so even a hand-corrupted record produces a
valid schedule.

---

## 5. Fire-Time Generation

`generateFireTimes()` expands every enabled project into concrete
`DateTime` fires:

- **Daily**: next **7 days**, one fire per slot per day
  (3 slots × 7 days = up to 21 fires per project).
- **Weekly**: next **14 days**, fires only on matching weekdays
  (14 days always covers the next matching weekday at least once).

Every fire is then **grouped by exact instant** → `Map<DateTime, List<Project>>`.
Two projects landing on the same minute share one key — this is the whole
grouping rule; there is no fuzziness of "same minute-ish".

### Rolling window & cap

`resync()` keeps only fires **strictly in the future**, sorted
oldest-first, and takes at most **50** (`_maxPending`). Newest-dropped
fires are naturally covered by the next resync. Practical effect:
a live schedule holds the next ~2–7 days, and simply using the app
(every mutation resyncs) keeps sliding the window forward.

---

## 6. Scheduling & Notification Identity

One `zonedSchedule` **one-shot** per fire instant
(`AndroidScheduleMode.inexactAllowWhileIdle` — exact-alarm permission is
deliberately not required; batch-fire jitter of a minute or two is
acceptable for check-in nudges).

### Notification ids (deterministic, state-derived)

Ids must be **stable across resyncs of identical state** so that
`cancelAll()` + re…register replaces rather than duplicates:

```
individual = projectId.hashCode ^ (hh*60 + mm) ^ dayIndexFromToday
digest     = 0x1D6 ^ (hh*60 + mm)        (date-independent)
```

- The `dayIndex` term separates "today 09:00" from "tomorrow 09:00".
- Digest ids are date-independent on purpose: digests are always scheduled
  immediately after `cancelAll()`, so an id reused across days is always a
  **replacement**, never a stale survivor.
- Ids depend only on state, never on wall clock at scheduling time — the
  same state always produces the same pending set.

### Grouping on the Android side

All reminders share:
- channel `flowi_project_reminders` (importance HIGH, created eagerly at
  init so display never depends on implicit channel creation),
- group key `flowi_project_reminders`; the **digest** notification is the
  Android group summary (`setAsGroupSummary`).

So when 3 projects fire at 09:00, the user sees one summary notification
containing the group — not 3 separate intrusions.

### Content

| | Individual | Digest |
|---|---|---|
| Title | `📌 {title} ({percent}%)` | `Flowi • {n} Active Projects Today` |
| Body | `{remaining} tasks remaining • Due {date}` | 1 project: `{name} needs attention.` · 2 projects: `{a} and {b} need attention.` (each named once) · 3+: first 2 names, then `"and {k} more need attention."` |
| Tap payload | `{kind: 'project', projectIds: [id]}` | `{kind: 'digest', projectIds: [...all...]}` |

Tap routing (in-service callback, works while app is running):
`kind: 'project'` → opens that project's edit screen **after fetching it**;
if the project was deleted meanwhile, falls through to home silently.
`kind: 'digest'` → home.

---

## 7. When the Schedule Rebuilds

`resync()` is called:

| Trigger | Where |
|---|---|
| App start (after Hive boxes open) | `main()` → `NotificationService.initAndSync()` |
| Any global reminder change | `SettingCubit` (after every commit) |
| Any project create / edit / delete / status change | `ProjectCubit` |

Every mutation re-aligns the schedule immediately. That is why editing a
time chip produces two rapid "Scheduled …" resyncs in the logs — commit
then resync, per chip.

---

## 8. Edge Cases — and where each is handled

| Edge case | Handling |
|---|---|
| **Project deleted** | Nothing special needed: `resync()` recomputes from `ProjectStore.readAll()`; the deleted project simply produces no fires, and `cancelAll()` wiped its pending ones. Tap-open of a deleted project is separately guarded (fetch-then-navigate, home fallback). |
| **Settings changed many times in a row** | Each commit triggers `cancelAll()` + recompute; the last commits' result wins. Since ids are state-derived, an identical state re-registers identical ids — no duplicates, no stale entries. |
| **Custom schedule collides with a global fire** | Collisions resolve naturally by **exact-instant grouping**: if a custom slot and a global slot hit the same minute, both projects feed one digest for that minute. If they differ by even a minute, they stay two separate notifications. |
| **Multiple projects, same fire time (global cadence)** | Same rule — one digest per minute. 1 project ⇒ individual with the Android group key, 2+ ⇒ digest acting as the group summary. |
| **Multiple slots fire in quick sequence (e.g. 3×/day)** | Each minute gets its own independent alarm; nothing accumulates because each subsequent resync starts from `cancelAll()`. |
| **endDate passed** | Stop condition #2, evaluated *before* scheduling: notify **up to and including** the end-date day; from the day after it, the project is dead. Day granularity — a reminder at 09:00 still fires on the end-date day itself. |
| **Project completed** | Stop condition #1 — completed projects are excluded from fire-time generation entirely; no notification is ever scheduled. Completing a project mid-window cleans up on the next resync (project edit commits trigger resync). |
| **Global switch OFF** | 'Default' projects silenced (step 5a). Projects in `custom` mode **keep firing** — custom is independent of the global config. `resync()` short-circuits after `cancelAll()` only when nothing is enabled. |
| **Scope = Selected, project not picked** | Stop condition 5b. Removing a project from selection at the project level is reflected on next resync. |
| **Corrupt / old data** | Global config: tolerant `fromMap` (missing keys → defaults; malformed times dropped; weekday range-filtered). Old project records: adapter reads new fields as `null` ⇒ treated as `'default'`. Slots re-clamped at resolution, so bad data can never reach `AlarmManager`; custom weekly weekdays are range-filtered too; a weekly custom record with an *empty* slots list falls back to `09:00` instead of crashing. |
| **Project edited after a custom reminder was set** | `ProjectModel.copyWith` forwards `reminderMode` / `customSlots` / `customWeekdays`, so any edit (title, tasks, status, dates) keeps the custom reminder intact instead of silently resetting it to `'default'`. |
| **Reminder system errors** | All service calls are wrapped and logged (`DebugLogger`); a broken reminder system never takes the UI down. |
| **Permission revoked after granting** | Scheduling continues silently, but every `resync()` logs `OS notifications enabled: false`, making the situation visible in debug output. Scheduling itself never crashes on a revoked permission — Android still accepts the alarms, display is just suppressed. |
| **Reboot** | The boot receiver (`ScheduledNotificationBootReceiver`, declared in the app manifest with `BOOT_COMPLETED` / `QUICKBOOT_POWERON`) re-delivers pending alarms from the plugin's persisted schedule. Declared `exported="false"`. |
| **Alarm fired at boot but app never opened** | Covered by the plugin's persisted notification cache; the schedule reconciles on next app start. |
| **Device timezone oddities** | `_initTimezones()` tries the OS-reported zone name, then the raw name, and finally falls back to `Africa/Cairo` so scheduling always has a valid zone. If a fire lands at the wrong wall-clock hour on a device with a weird zone, this fallback is the first suspect. |

---

## 9. Android Manifest Contract (why it's ours)

Since `flutter_local_notifications` v16, the plugin library manifest
declares **no receivers** — the app must declare both:

```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
          android:exported="false"/>   <!-- fire path: AlarmManager targets this -->
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
          android:exported="false">    <!-- reboot path -->
    <intent-filter> BOOT_COMPLETED / QUICKBOOT_POWERON </intent-filter>
</receiver>
```

Plus permissions: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`.
Missing the fire receiver manifests as alarms firing with **no log, no
crash, no notification** — the broadcast being dropped into nothing.

### Runtime permission flow

Never requested at boot. The single request point is **toggling the global
master switch ON** in Settings; if denied, the switch stays off and a
snackbar explains. Config is only persisted when the grant succeeds.

---

## 10. Testing Notes

- The resolver is **pure** (models only, no plugin imports) — designed for
  direct unit tests of the decision chain, slot clamping, fire-time
  generation, and digest content.
- Two rapid resyncs per settings edit are **by design** (commit → resync).
- Never "Force stop" the app during manual testing — it cancels all
  pending alarms. Recent-apps swipe is safe.
- Diagnostics: every `resync()` logs the rolling-window explanation,
  the next fire instant, `OS notifications enabled`, and the pending
  count after sync.
- Known live constraints on the test device (vivo V2109): the main
  logcat buffer is heavily suppressed — use `dumpsys notification` /
  `dumpsys alarm` for inspection rather than logcat greps.
