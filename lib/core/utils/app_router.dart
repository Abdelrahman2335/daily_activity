import 'package:daily_activity/layout.dart';
import 'package:daily_activity/features/home/presentation/views/home_view.dart';
import 'package:daily_activity/features/welcome/presentation/views/welcome_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const String kHomePage = "/home";
  static const String kMainNavigationBar = "/main_navigation";
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => WelcomeView(),
    ),
    GoRoute(
      path: kMainNavigationBar,
      builder: (context, state) => LayOut(),
    ),
    GoRoute(
      path: kHomePage,
      builder: (context, state) => HomeView(),
    ),
  ]);
}
