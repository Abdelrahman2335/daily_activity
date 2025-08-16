import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/features/project/presentation/views/project_view.dart';
import 'package:daily_activity/features/home/presentation/views/today_task_view.dart';
import 'package:daily_activity/features/settings/presentation/views/settings_view.dart';
import 'package:daily_activity/layout.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
import 'package:daily_activity/features/welcome/presentation/views/welcome_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const String kHomePage = "/home";
  static const String kLayOut = "/layOut";
  static const String kTodayTasks = "/todayTasks";
  static const String kAddProject = "/addTask";
  static const String kEditProject = "/addTask";
  static const String kSettings = "/settings";
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => WelcomeView(),
    ),
    GoRoute(
      path: kLayOut,
      builder: (context, state) => LayOut(),
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
        final isEditMood = state.extra as bool;
        return ProjectView(
          isEditMood: isEditMood,
        );
      },
    ),
    GoRoute(
      path: kEditProject,
      builder: (context, state) {
        final project = state.extra as ProjectModel;
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
