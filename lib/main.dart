import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/adapters/date_time_adapter.dart';
import 'package:daily_activity/core/adapters/icon_adapter.dart';
import 'package:daily_activity/core/models/project_category.dart';
import 'package:daily_activity/core/models/project_model.dart';
import 'package:daily_activity/core/models/project_status.dart';
import 'package:daily_activity/core/models/task_model.dart';
import 'package:daily_activity/core/utils/app_router.dart';
import 'package:daily_activity/core/utils/bloc_observer.dart';
import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/core/utils/theme_manager.dart';
import 'package:daily_activity/features/home/data/repository/home_repo_impl.dart';
import 'package:daily_activity/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:daily_activity/features/settings/presentation/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Bloc.observer = AppBlocObserver();
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(ProjectCategoryAdapter());
  Hive.registerAdapter(ProjectCategoryModelAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(DateTimeAdapter());
  Hive.registerAdapter(IconAdapter());

  await Hive.openBox<ProjectModel>(Constants.kMainBox);
  await Hive.openBox(Constants.kSettingsBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(HomeRepoImpl()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'Daily Activity',
            debugShowCheckedModeBanner: false,
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
