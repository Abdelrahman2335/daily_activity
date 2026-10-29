import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flowi/features/settings/presentation/views/settings_view.dart';
import 'package:flowi/features/settings/presentation/views/terms_view.dart';
import 'package:flowi/features/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'support/fakes.dart';
import 'support/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    registerTestFallbacks();
    await TestFonts.load();
  });

  setUp(() async {
    await TestHive.ensureOpen();
  });

  group('WelcomeView', () {
    testWidgets('renders title, description, and CTA button', (tester) async {
      await pumpScreen(tester, const WelcomeView());

      expect(find.text('Task Management &\n To-Do List'), findsOneWidget);
      expect(find.text(Constants.appDescription), findsOneWidget);
      expect(find.text("Let's Start"), findsOneWidget);
      // The hero illustration (Image.asset on a real PNG).
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        "tapping Let's Start persists isFirstLaunch=false and navigates to layout",
        (tester) async {
      // Hive writes are real disk I/O that never resolves inside the
      // FakeAsync zone, so the seed must run under tester.runAsync.
      await tester.runAsync(() async {
        await Hive.box(Constants.kSettingsBox)
            .put(Constants.isFirstLaunchKey, true);
      });
      await pumpScreen(tester, const WelcomeView());

      await tester.tap(find.text("Let's Start"));
      // The CTA's onPressed also awaits a Hive write before navigating, so it
      // needs real time (not fake) to finish.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      expect(
        Hive.box(Constants.kSettingsBox).get(Constants.isFirstLaunchKey),
        isFalse,
      );
      expect(find.text('stub:layout'), findsOneWidget);
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      await expectNoLayoutDefects(tester, const WelcomeView());
    });
  });

  group('SettingsView', () {
    Widget screen() {
      return BlocProvider<SettingCubit>(
        create: (_) => SeedableSettingCubit(),
        child: const SettingsView(),
      );
    }

    testWidgets('renders name field, dark theme switch, terms button, and app version',
        (tester) async {
      await pumpScreen(tester, screen());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Dark Theme'), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text(Constants.appVersion), findsOneWidget);
    });

    testWidgets('typing a name updates SettingCubit and persists to Hive',
        (tester) async {
      await pumpScreen(tester, screen());

      await tester.enterText(find.byType(TextField), 'Abdelrahman');
      // The cubit persists the name through a background Hive write (real
      // disk I/O); give it real time to commit before asserting.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump();

      expect(
        Hive.box(Constants.kSettingsBox).get(Constants.userNameKey),
        equals('Abdelrahman'),
      );
    });

    testWidgets('toggling Dark Theme switch flips SettingCubit.isDark',
        (tester) async {
      final cubit = SeedableSettingCubit();
      await pumpScreen(
        tester,
        BlocProvider<SettingCubit>(
          create: (_) => cubit,
          child: const SettingsView(),
        ),
      );

      expect(cubit.isDark, isFalse);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();

      expect(cubit.isDark, isTrue);
    });

    testWidgets('tapping Terms & Conditions pushes the terms route',
        (tester) async {
      await pumpScreen(tester, screen());

      await tester.tap(find.text('Terms & Conditions'));
      await tester.pumpAndSettle();

      expect(find.text('stub:terms'), findsOneWidget);
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      await expectNoLayoutDefects(tester, screen());
    });
  });

  group('TermsView', () {
    testWidgets('renders terms copy and unlabeled back button (known defect)',
        (tester) async {
      await pumpScreen(tester, const TermsView());

      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text(Constants.terms), findsOneWidget);
      // Known defect: the AppBar back IconButton has no tooltip/semantics
      // label, so it is announced to screen readers as a bare icon.
      expect(unlabeledIconButtons(tester), isNotEmpty);
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      await expectNoLayoutDefects(tester, const TermsView());
    });
  });
}
