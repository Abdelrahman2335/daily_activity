import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/home/presentation/views/today_task_view.dart';
import 'package:flowi/features/home/presentation/widgets/custom_calender_card.dart';
import 'package:flowi/features/home/presentation/widgets/custom_today_task.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';
import 'support/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    registerTestFallbacks();
    await TestFonts.load();
  });

  late MockHomeRepo homeRepo;

  setUp(() async {
    await TestHive.ensureOpen();
    homeRepo = buildHomeRepo();
  });

  Widget today(HomeState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(create: (_) => SeedableSettingCubit()),
        BlocProvider<HomeCubit>(
          create: (_) {
            final cubit = SeedableHomeCubit(homeRepo);
            cubit.seed(state);
            return cubit;
          },
        ),
      ],
      child: const TodayTasksView(),
    );
  }

  group('TodayTasksView', () {
    testWidgets('loading state builds a skeleton list without crashing',
        (tester) async {
      // BUG (see report): `FilteredProjects` builds its 5 skeleton cards with
      // `CustomTodayTaskCard(project: displayedProjects, index: 5)`. During
      // loading `displayedProjects` is empty, so `project[5]` throws a
      // RangeError five times per frame.
      final defects = await collectLayoutDefects(
        tester,
        today(HomeLoading()),
        settle: false,
      );

      expect(
        defects.where((d) => d.message.contains('RangeError')),
        isNotEmpty,
        reason: 'Expected the known RangeError while rendering the skeleton '
            'list. If this is empty the bug was fixed and this test can be '
            'rewritten as a clean-render assertion.',
      );
    });

    testWidgets('empty state shows headers and no project cards',
        (tester) async {
      await pumpScreen(tester, today(HomeSuccess(const [])));

      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('All Projects'), findsOneWidget);
      expect(find.byType(CustomTodayTaskCard), findsNothing);
      // The calendar strip disappears entirely when there is no project to
      // derive a date range from.
      expect(find.byType(CustomCalenderCard), findsNothing);
    });

    testWidgets('populated state shows a card per project and a calendar strip',
        (tester) async {
      final projects = <ProjectModel>[
        sampleProject(title: 'Ship the MVP'),
        sampleProject(title: 'Read two books', status: TaskStatus.completed),
      ];
      homeRepo = buildHomeRepo(projects: projects);
      await pumpScreen(tester, today(HomeSuccess(projects)));

      expect(find.byType(CustomTodayTaskCard), findsNWidgets(2));
      expect(find.text('Ship the MVP'), findsOneWidget);
      expect(find.text('Read two books'), findsOneWidget);
      expect(find.byType(CustomCalenderCard), findsWidgets);
      expect(find.text('In Progress'), findsWidgets);
    });

    testWidgets('error state renders nothing and offers no retry',
        (tester) async {
      await pumpScreen(tester, today(HomeError('Failed to load projects')));

      // The screen has no error branch: the failure is silently swallowed and
      // the user sees an empty project list.
      expect(find.text('Failed to load projects'), findsNothing);
      expect(find.byType(CustomTodayTaskCard), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('status chips re-colour on tap', (tester) async {
      homeRepo = buildHomeRepo(projects: <ProjectModel>[sampleProject()]);
      await pumpScreen(tester, today(HomeSuccess([sampleProject()])));

      final chips = find.byType(ElevatedButton);
      expect(chips, findsNWidgets(4));

      Color? background(int index) => tester
          .widget<ElevatedButton>(chips.at(index))
          .style
          ?.backgroundColor
          ?.resolve(<WidgetState>{});

      final before = List<Color?>.generate(4, background);
      await tester.tap(chips.at(1));
      await tester.pumpAndSettle();
      final after = List<Color?>.generate(4, background);

      expect(after, isNot(equals(before)));
    });

    testWidgets('tapping a calendar day does not change the selection',
        (tester) async {
      homeRepo = buildHomeRepo(projects: <ProjectModel>[sampleProject()]);
      await pumpScreen(tester, today(HomeSuccess([sampleProject()])));

      // BUG (see report): `CustomCalenderList` keeps `selectedIndex` as a local
      // variable and mutates it inside `onTap` without `setState`, so the
      // tapped day never highlights.
      Color? dayBackground(int index) {
        final finder = find
            .descendant(
              of: find.byType(GridView),
              matching: find.byType(Container),
            )
            .at(index);
        final decoration = tester.widget<Container>(finder).decoration;
        return (decoration as BoxDecoration?)?.color;
      }

      final before = dayBackground(1);
      await tester.tap(find.byType(GridView).first);
      await tester.pumpAndSettle();
      final after = dayBackground(1);

      expect(
        after,
        before,
        reason: 'Known defect: the calendar does not repaint the selection. '
            'When fixed, this expectation should flip to isNot(before).',
      );
    });

    testWidgets('renders at 1.5x text with a bottom overflow (known defect)',
        (tester) async {
      homeRepo = buildHomeRepo(projects: <ProjectModel>[sampleProject()]);
      final defects = await collectLayoutDefects(
        tester,
        today(HomeSuccess(<ProjectModel>[sampleProject()])),
        configs: const <ScreenConfig>[
          ScreenConfig(textScale: kLargeTextScale),
        ],
      );
      // The calendar card's Column overflows because the card height comes from
      // `SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.4)`
      // rather than from its text.
      expect(
        defects.where((d) => d.message.contains('overflowed')),
        isNotEmpty,
        reason: 'Expected the known calendar-card overflow. If empty, the bug '
            'was fixed and this test can become a clean-render assertion.',
      );
    });

    testWidgets('renders at default text scale without layout defects',
        (tester) async {
      await expectNoLayoutDefects(
        tester,
        today(HomeSuccess(<ProjectModel>[sampleProject()])),
        configs: const <ScreenConfig>[
          ScreenConfig(),
          ScreenConfig(themeMode: ThemeMode.dark),
          ScreenConfig(size: kSmallScreenSize),
          ScreenConfig(themeMode: ThemeMode.dark, size: kSmallScreenSize),
        ],
      );
    });
  });
}
