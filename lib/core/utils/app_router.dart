import 'package:daily_activity/features/home/presentation/pages/home_page.dart';
import 'package:daily_activity/features/welcome/presentation/pages/welcome_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const String kHomePage = "/home";
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => WelcomeView(),
    ),
    GoRoute(
      path: kHomePage,
      builder: (context, state) => HomeView(),
    ),
  ]);
}
