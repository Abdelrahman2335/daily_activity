import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/home/presentation/widgets/home_view_body.dart';
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

  Widget home(HomeState state) {
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
      child: const Material(child: HomeViewBody()),
    );
  }

  group('HomeViewBody', () {
    testWidgets('loading state renders skeleton placeholders', (tester) async {
      await pumpScreen(tester, home(HomeLoading()), settle: false);

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Overall progress \nKeep it up!'), findsOneWidget);
    });

    testWidgets('empty state shows the section headers but no cards',
        (tester) async {
      await pumpScreen(tester, home(HomeSuccess(const [])));

      expect(find.text('Projects'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      // The screen offers no way to create the first project.
      expect(find.textContaining('Add'), findsNothing);
    });

    testWidgets('populated state lists one card per project', (tester) async {
      final projects = <ProjectModel>[
        sampleProject(title: 'Ship the MVP'),
        sampleProject(
          title: 'Read two books',
          status: TaskStatus.completed,
          tasks: const [],
        ),
      ];
      homeRepo = buildHomeRepo(
        projects: projects,
        overallProgress: '50',
      );

      await pumpScreen(tester, home(HomeSuccess(projects)));

      expect(find.text('Ship the MVP'), findsOneWidget);
      expect(find.text('Read two books'), findsOneWidget);
      // Known defect: the ring interpolates the raw double, so a 50% project
      // renders as "50.0%".
      expect(find.text('50.0%'), findsOneWidget);
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('error state renders the raw error message', (tester) async {
      await pumpScreen(tester, home(HomeError('Failed to load projects')));

      expect(find.text('Failed to load projects'), findsOneWidget);
      // No retry affordance is offered to the user.
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('in-progress carousel appears only when projects are in progress',
        (tester) async {
      final inProgress = sampleProject(title: 'In flight');
      homeRepo = buildHomeRepo(
        projects: <ProjectModel>[inProgress],
        inProgress: <ProjectModel>[inProgress],
      );
      await pumpScreen(tester, home(HomeSuccess([inProgress])));
      expect(find.text('In Progress'), findsOneWidget);

      homeRepo = buildHomeRepo(projects: const []);
      await pumpScreen(tester, home(HomeSuccess(const [])));
      expect(find.text('In Progress'), findsNothing);
    });

    testWidgets('greeting falls back to "Hello There!" without a saved name',
        (tester) async {
      await pumpScreen(tester, home(HomeSuccess(const [])));

      expect(find.text('Hello There!'), findsOneWidget);
      expect(find.text('Hello!'), findsNothing);
    });

    testWidgets('renders in light and dark mode', (tester) async {
      for (final mode in <ThemeMode>[ThemeMode.light, ThemeMode.dark]) {
        await pumpScreen(
          tester,
          home(HomeSuccess(<ProjectModel>[sampleProject()])),
          config: ScreenConfig(themeMode: mode),
        );
        final context = tester.element(find.byType(HomeViewBody));
        expect(Theme.of(context).brightness, mode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light);
      }
    });

    testWidgets('survives 1.5x text on a 360x640 screen', (tester) async {
      await expectNoLayoutDefects(
        tester,
        home(HomeSuccess(<ProjectModel>[sampleProject()])),
      );
    });
  });
}
