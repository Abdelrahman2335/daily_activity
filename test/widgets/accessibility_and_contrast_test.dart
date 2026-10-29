import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/app_colors.dart';
import 'package:flowi/core/utils/theme_manager.dart';
import 'package:flowi/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:flowi/features/ai_assistant/presentation/views/widgets/ai_assistant_view_body.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/home/presentation/widgets/home_view_body.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flowi/features/project/presentation/widgets/add_project_view_body.dart';
import 'package:flowi/features/project/presentation/widgets/edit_project_view_body.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flowi/features/settings/presentation/views/terms_view.dart';
import 'package:flowi/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';
import 'support/widget_test_harness.dart';

double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  setUpAll(() async {
    registerTestFallbacks();
    await TestFonts.load();
  });

  late MockHomeRepo homeRepo;

  setUp(() async {
    await TestHive.ensureOpen();
    homeRepo = buildHomeRepo(projects: <ProjectModel>[sampleProject()]);
  });

  group('Theme contrast audit (WCAG AA 4.5:1)', () {
    test('light and dark primary body text (onSurface/surface) passes WCAG AA',
        () {
      final light = ThemeManager.lightTheme.colorScheme;
      final dark = ThemeManager.darkTheme.colorScheme;

      expect(_contrastRatio(light.onSurface, light.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(dark.onSurface, dark.surface), greaterThanOrEqualTo(4.5));
    });

    test(
        'documents known contrast failures in dark mode and light mode (known defects)',
        () {
      final light = ThemeManager.lightTheme.colorScheme;
      final dark = ThemeManager.darkTheme.colorScheme;

      // Dark mode: onPrimary on primary (~1.94:1) and primary on surface (~2.46:1)
      expect(_contrastRatio(dark.onPrimary, dark.primary), lessThan(3.0));
      expect(_contrastRatio(dark.primary, dark.surface), lessThan(3.0));

      // Light mode: accentOrange on surface (~1.97:1) and textSecondary on surface (~2.68:1)
      expect(_contrastRatio(AppColor.accentOrange, light.surface), lessThan(3.0));
      expect(_contrastRatio(AppColor.textSecondary, light.surface), lessThan(3.0));
    });
  });

  group('Semantics & tooltip audit (known defects)', () {
    testWidgets(
        'TermsView, AddProjectViewBody, EditProjectViewBody, and AiAssistantViewBody have unlabeled IconButtons',
        (tester) async {
      await pumpScreen(tester, const TermsView());
      expect(unlabeledIconButtons(tester), isNotEmpty);

      final repo = buildProjectRepo();
      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );
      expect(unlabeledIconButtons(tester), isNotEmpty);

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(
                repo,
                initialProject: sampleProject(),
              ),
            ),
          ],
          child: const Scaffold(body: EditProjectViewBody()),
        ),
      );
      expect(unlabeledIconButtons(tester), isNotEmpty);

      await pumpScreen(
        tester,
        BlocProvider<AiAssistantCubit>(
          create: (_) => SeedableAiCubit(),
          child: const Scaffold(body: AiAssistantViewBody()),
        ),
      );
      expect(unlabeledIconButtons(tester), isNotEmpty);
    });

    testWidgets('LayOut FloatingActionButton lacks a tooltip', (tester) async {
      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<SettingCubit>(create: (_) => SeedableSettingCubit()),
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
          ],
          child: const LayOut(),
        ),
      );

      expect(unlabeledFab(tester), isNotEmpty);
    });
  });

  group('In-progress card 1.5x text scale overflow (known defect)', () {
    testWidgets(
        'HomeViewBody with an in-progress project overflows InProgressTodo Column at 1.5x text scale',
        (tester) async {
      final inProgress = sampleProject(
        status: TaskStatus.inProgress,
        tasks: <TaskModel>[TaskModel(title: 'a', isCompleted: true)],
      );
      homeRepo = buildHomeRepo(
        projects: <ProjectModel>[inProgress],
        inProgress: <ProjectModel>[inProgress],
        overallProgress: '100',
        projectProgress: '100%',
      );

      final defects = await collectLayoutDefects(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider<SettingCubit>(create: (_) => SeedableSettingCubit()),
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
          ],
          child: const Material(child: HomeViewBody()),
        ),
        configs: const <ScreenConfig>[
          ScreenConfig(textScale: kLargeTextScale),
        ],
      );

      if (!TestFonts.available) return;
      expect(
        defects.where((d) => d.message.contains('overflowed')),
        isNotEmpty,
        reason: 'Expected InProgressTodo Column bottom overflow (~13px) at 1.5x.',
      );
    });
  });
}
