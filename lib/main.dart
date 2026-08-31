import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/app_router.dart';
import 'package:flowi/core/utils/bloc_observer.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/core/utils/theme_manager.dart';
import 'package:flowi/features/home/data/repository/home_repo_impl.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: ".env");
  //
  // // Initialize Gemini Service with API key from .env
  // GeminiService().initialize();

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
        // BlocProvider(create: (context) => AiAssistantCubit()),
        BlocProvider(
          create: (context) => SettingCubit(),
        ),
      ],
      child: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          bool isDarkMode = context.read<SettingCubit>().isDark;
          return AnimatedTheme(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 700),
            data: isDarkMode ? ThemeManager.darkTheme : ThemeManager.lightTheme,
            child: MaterialApp.router(
              routerConfig: AppRouter.router,
              title: Constants.appName,
              debugShowCheckedModeBanner: false,
              theme: ThemeManager.lightTheme,
              darkTheme: ThemeManager.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            ),
          );
        },
      ),
    );
  }
}
