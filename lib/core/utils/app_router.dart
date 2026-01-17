import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/features/ai_assistant/presentation/views/screens/ai_assistant_view.dart';
import 'package:daily_activity/features/project/presentation/views/project_view.dart';
import 'package:daily_activity/features/home/presentation/views/today_task_view.dart';
import 'package:daily_activity/features/settings/presentation/views/settings_view.dart';
import 'package:daily_activity/layout.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
import 'package:daily_activity/features/welcome/presentation/views/welcome_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AppRouter {
  static const String kHomePage = "/home";
  static const String kLayOut = "/layOut";
  static const String kWelcome = "/welcome";
  static const String kAiAssistant = "/aiAssistant";
  static const String kTodayTasks = "/todayTasks";
  static const String kAddProject = "/addProject";
  static const String kEditProject = "/editProject";
  static const String kSettings = "/settings";
  static final GoRouter router = GoRouter(
    redirect: (context, state) {
      final settingsBox = Hive.box(Constants.kSettingsBox);
      final isFirstLaunch = settingsBox.get(Constants.isFirstLaunchKey, defaultValue: true);

      // If it's the first launch and not already on welcome screen, redirect to welcome
      if (isFirstLaunch && state.matchedLocation != kWelcome) {
        return kWelcome;
      }

      // If not first launch and on welcome screen, redirect to layout
      if (!isFirstLaunch && state.matchedLocation == kWelcome) {
        return kLayOut;
      }

      // If on root path and not first launch, go to layout
      if (state.matchedLocation == '/' && !isFirstLaunch) {
        return kLayOut;
      }

      return null; // No redirect needed
    },
    routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const WelcomeView(),
    ),
    GoRoute(
      path: kWelcome,
      builder: (context, state) => const WelcomeView(),
    ),
    GoRoute(
      path: kLayOut,
      builder: (context, state) => const LayOut(),
    ),
    GoRoute(
      path: kAiAssistant,
      builder: (context, state) => AiAssistantView(),
    ),
    GoRoute(
      path: kHomePage,
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      path: kTodayTasks,
      builder: (context, state) => const TodayTasksView(),
    ),
    GoRoute(
      path: kAddProject,
      builder: (context, state) {
        return ProjectView(
          isEditMood: false,
        );
      },
    ),
    GoRoute(
      path: kEditProject,
      builder: (context, state) {
        final project = state.extra as ProjectModel?;
        return ProjectView(
          isEditMood: true,
          project: project,
        );
      },
    ),
    GoRoute(
      path: kSettings,
      builder: (context, state) => const SettingsView(),
    ),
  ]);
}
