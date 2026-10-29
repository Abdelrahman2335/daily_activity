import 'dart:io';

import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/app_router.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/core/utils/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

// ---------------------------------------------------------------------------
// Screens under test
// ---------------------------------------------------------------------------

/// Logical screen size of a modern phone (iPhone 14 class).
const Size kDefaultScreenSize = Size(390, 844);

/// Logical screen size of a small/low-end Android phone.
const Size kSmallScreenSize = Size(360, 640);

/// Android's "Largest" accessibility font setting.
const double kLargeTextScale = 1.5;

/// One point in the visual matrix: theme x text scale x screen size.
@immutable
class ScreenConfig {
  const ScreenConfig({
    this.themeMode = ThemeMode.light,
    this.textScale = 1.0,
    this.size = kDefaultScreenSize,
  });

  final ThemeMode themeMode;
  final double textScale;
  final Size size;

  bool get isDark => themeMode == ThemeMode.dark;

  String get themeName => isDark ? 'dark' : 'light';

  @override
  String toString() =>
      '$themeName/${textScale}x/${size.width.toInt()}x${size.height.toInt()}';

  /// Both themes x {1.0x, 1.5x} text x {390x844, 360x640}.
  static const List<ScreenConfig> matrix = <ScreenConfig>[
    ScreenConfig(),
    ScreenConfig(themeMode: ThemeMode.dark),
    ScreenConfig(textScale: kLargeTextScale),
    ScreenConfig(themeMode: ThemeMode.dark, textScale: kLargeTextScale),
    ScreenConfig(size: kSmallScreenSize),
    ScreenConfig(themeMode: ThemeMode.dark, size: kSmallScreenSize),
    ScreenConfig(size: kSmallScreenSize, textScale: kLargeTextScale),
    ScreenConfig(
      themeMode: ThemeMode.dark,
      size: kSmallScreenSize,
      textScale: kLargeTextScale,
    ),
  ];
}

// ---------------------------------------------------------------------------
// Fonts
// ---------------------------------------------------------------------------

/// Loads a real proportional font into the test binary.
///
/// Without this the test binding falls back to "Ahem", a font whose every
/// glyph is a full em square. That inflates every string by ~40-100%, which
/// produces overflow errors that do not reproduce on a device. All overflow
/// assertions are therefore gated on [TestFonts.available].
abstract final class TestFonts {
  static bool available = false;
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    if (flutterRoot == null || flutterRoot.isEmpty) return;

    final fontDir = Directory(
      '$flutterRoot/bin/cache/artifacts/material_fonts',
    );
    if (!fontDir.existsSync()) return;

    Future<void> register(String family, List<String> fileNames) async {
      final loader = FontLoader(family);
      var added = 0;
      for (final name in fileNames) {
        final file = File('${fontDir.path}/$name');
        if (!file.existsSync()) continue;
        loader.addFont(
          file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
        added++;
      }
      if (added == 0) return;
      await loader.load();
    }

    const roboto = <String>[
      'roboto-regular.ttf',
      'roboto-medium.ttf',
      'roboto-bold.ttf',
    ];
    // The app theme sets `fontFamily: 'sans-serif'`, so that family name has to
    // resolve too, not just the default 'Roboto'.
    await register('Roboto', roboto);
    await register('sans-serif', roboto);
    await register('MaterialIcons', <String>['materialicons-regular.otf']);

    available = true;
  }
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

/// Hosts [screen] at `/` and stubs every other app route.
///
/// Screens call `GoRouter.of(context)` directly, so a `GoRouter` must be in the
/// tree even when the test never navigates.
GoRouter buildTestRouter(Widget screen) {
  Widget stub(String name) => Scaffold(body: Center(child: Text('stub:$name')));

  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, __) => screen),
      GoRoute(path: AppRouter.kAddProject, builder: (_, __) => stub('add')),
      GoRoute(path: AppRouter.kEditProject, builder: (_, __) => stub('edit')),
      GoRoute(path: AppRouter.kTodayTasks, builder: (_, __) => stub('today')),
      GoRoute(path: AppRouter.kTerms, builder: (_, __) => stub('terms')),
      GoRoute(path: AppRouter.kLayOut, builder: (_, __) => stub('layout')),
      GoRoute(path: AppRouter.kSettings, builder: (_, __) => stub('settings')),
      GoRoute(path: AppRouter.kAiAssistant, builder: (_, __) => stub('ai')),
      GoRoute(path: AppRouter.kWelcome, builder: (_, __) => stub('welcome')),
    ],
  );
}

Widget wrapWithApp(Widget screen, ScreenConfig config, {GoRouter? router}) {
  return MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: router ?? buildTestRouter(screen),
    theme: ThemeManager.lightTheme,
    darkTheme: ThemeManager.darkTheme,
    themeMode: config.themeMode,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(config.textScale),
        ),
        child: child!,
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Pumping
// ---------------------------------------------------------------------------

/// Pumps [screen] inside a themed app at [config].
///
/// Pass `settle: false` for states with endless animations (skeleton shimmer,
/// wave dots); `pumpAndSettle` would time out on those.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  ScreenConfig config = const ScreenConfig(),
  bool settle = true,
  GoRouter? router,
}) async {
  tester.view.physicalSize = config.size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(wrapWithApp(screen, config, router: router));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// A layout defect captured while pumping a screen.
@immutable
class LayoutDefect {
  const LayoutDefect({required this.config, required this.message});

  final ScreenConfig config;
  final String message;

  @override
  String toString() => '[$config] $message';
}

/// Pumps [screen] for every config and returns the framework errors raised
/// while building/laying it out (overflow, assertion, range errors, ...).
///
/// Errors are captured instead of failing so callers can assert on them.
Future<List<LayoutDefect>> collectLayoutDefects(
  WidgetTester tester,
  Widget screen, {
  List<ScreenConfig> configs = ScreenConfig.matrix,
  bool settle = true,
}) async {
  final defects = <LayoutDefect>[];

  for (final config in configs) {
    final reported = <FlutterErrorDetails>[];
    final previousOnError = FlutterError.onError;
    FlutterError.onError = reported.add;
    try {
      await pumpScreen(tester, screen, config: config, settle: settle);
      // Let post-frame work (dialogs, listeners) run as well.
      await tester.pump(const Duration(milliseconds: 350));
    } catch (error) {
      defects.add(LayoutDefect(config: config, message: 'pump threw: $error'));
    } finally {
      FlutterError.onError = previousOnError;
    }

    for (final details in reported) {
      defects.add(
        LayoutDefect(
          config: config,
          message: details.exceptionAsString().split('\n').first.trim(),
        ),
      );
    }

    tester.takeException();
    await tester.pumpWidget(const SizedBox.shrink());
  }

  return defects;
}

/// Asserts [screen] lays out cleanly across the whole matrix.
///
/// Silently no-ops when no real font could be loaded, because Ahem's synthetic
/// glyph widths create overflows that never happen on a device.
Future<void> expectNoLayoutDefects(
  WidgetTester tester,
  Widget screen, {
  bool settle = true,
  List<ScreenConfig> configs = ScreenConfig.matrix,
}) async {
  final defects = await collectLayoutDefects(
    tester,
    screen,
    settle: settle,
    configs: configs,
  );
  if (!TestFonts.available) {
    // ignore: avoid_print
    print('SKIPPED overflow assertion (no real font loaded): $defects');
    return;
  }
  expect(
    defects,
    isEmpty,
    reason: 'layout defects:\n${defects.join('\n')}',
  );
}

// ---------------------------------------------------------------------------
// Accessibility helpers
// ---------------------------------------------------------------------------

String _iconName(IconData data) {
  final match = RegExp(r'U\+([0-9A-Fa-f]+)').firstMatch(data.toString());
  return match == null ? data.toString() : 'U+${match.group(1)}';
}

/// [IconButton]s that expose neither a tooltip nor a semantics label.
List<String> unlabeledIconButtons(WidgetTester tester) {
  final result = <String>[];
  for (final element in find.byType(IconButton).evaluate()) {
    final button = element.widget as IconButton;
    if (button.tooltip != null && button.tooltip!.isNotEmpty) continue;
    final icon = button.icon;
    final label =
        icon is Icon && icon.icon != null ? _iconName(icon.icon!) : '$icon';
    result.add('IconButton($label)');
  }
  return result;
}

/// [FloatingActionButton]s without a tooltip.
List<String> unlabeledFab(WidgetTester tester) {
  final result = <String>[];
  for (final element in find.byType(FloatingActionButton).evaluate()) {
    final fab = element.widget as FloatingActionButton;
    if (fab.tooltip != null && fab.tooltip!.isNotEmpty) continue;
    final child = fab.child;
    final label =
        child is Icon && child.icon != null ? _iconName(child.icon!) : '$child';
    result.add('FloatingActionButton($label)');
  }
  return result;
}

// ---------------------------------------------------------------------------
// Hive
// ---------------------------------------------------------------------------

/// Hive bootstrap for widget tests.
///
/// `SettingCubit` builds its own `SettingRepoImpl`, whose `_box` field
/// initializer reads the settings box immediately, so the boxes must exist
/// before the cubit is constructed. There is no injection point to avoid this.
abstract final class TestHive {
  static Directory? _directory;
  static bool _initialized = false;

  static Future<void> ensureOpen({
    bool isDark = false,
    String userName = '',
  }) async {
    if (!_initialized) {
      _directory = await Directory.systemTemp.createTemp('flowi_widget_test_');
      Hive.init(_directory!.path);
      Hive.registerAdapter(ProjectModelAdapter());
      Hive.registerAdapter(ProjectCategoryAdapter());
      Hive.registerAdapter(ProjectCategoryModelAdapter());
      Hive.registerAdapter(TaskStatusAdapter());
      Hive.registerAdapter(TaskModelAdapter());
      Hive.registerAdapter(DateTimeAdapter());
      Hive.registerAdapter(IconAdapter());
      await Hive.openBox<ProjectModel>(Constants.kMainBox);
      await Hive.openBox(Constants.kSettingsBox);
      _initialized = true;
    }

    final settings = Hive.box(Constants.kSettingsBox);
    await settings.put(Constants.themeKey, isDark);
    await settings.put(Constants.userNameKey, userName);
    await settings.put(Constants.isFirstLaunchKey, false);
  }

  static Future<void> clearProjects() async {
    await Hive.box<ProjectModel>(Constants.kMainBox).clear();
  }
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

ProjectModel sampleProject({
  String title = 'Ship the MVP',
  String description = 'Finish the checkout flow before Friday.',
  ProjectCategory category = ProjectCategory.work,
  TaskStatus status = TaskStatus.inProgress,
  List<TaskModel>? tasks,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return ProjectModel(
    title: title,
    description: description,
    category: categories[category]!,
    startDate: startDate ?? DateTime(2026, 10, 20),
    endDate: endDate ?? DateTime(2026, 10, 30),
    tasks: tasks ??
        <TaskModel>[
          TaskModel(title: 'Design the flow', isCompleted: true),
          TaskModel(title: 'Wire the payment sheet'),
        ],
    status: status,
  );
}
