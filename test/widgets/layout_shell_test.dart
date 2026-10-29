import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/home/presentation/widgets/home_view_body.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flowi/features/settings/presentation/widgets/settings_view_body.dart';
import 'package:flowi/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';

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
    homeRepo = buildHomeRepo(projects: [sampleProject()]);
  });

  Widget buildShell() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(create: (_) => SeedableSettingCubit()),
        BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
      ],
      child: const LayOut(),
    );
  }

  group('LayOut shell', () {
    testWidgets(
        'defaults to HomeViewBody and exposes an unlabeled FAB (known defect)',
        (tester) async {
      await pumpScreen(tester, buildShell());

      expect(find.byType(HomeViewBody), findsOneWidget);
      expect(find.byType(SettingsViewBody), findsNothing);
      // Known defect: the FAB has no tooltip, so its "add project"
      // affordance is invisible to screen readers.
      expect(
        unlabeledFab(tester),
        ['FloatingActionButton(U+0E047)'],
      );
    });

    testWidgets('tapping bottom navigation bar switches between Home and Settings',
        (tester) async {
      await pumpScreen(tester, buildShell());

      await tester.tap(find.byIcon(Iconsax.user));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsViewBody), findsOneWidget);

      await tester.tap(find.byIcon(Iconsax.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomeViewBody), findsOneWidget);
    });

    testWidgets('tapping the FAB pushes the add-project route',
        (tester) async {
      await pumpScreen(tester, buildShell());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('stub:add'), findsOneWidget);
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      await expectNoLayoutDefects(tester, buildShell());
    });
  });
}
