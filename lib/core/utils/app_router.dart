import 'package:daily_activity/features/home/presentation/views/today_task_view.dart';
import 'package:daily_activity/layout.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
import 'package:daily_activity/features/welcome/presentation/views/welcome_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const String kHomePage = "/home";
  static const String kLayOut = "/layOut";
  static const String kTodayTasks = "/todayTasks";
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
  ]);
}
