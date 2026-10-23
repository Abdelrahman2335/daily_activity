// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For abdelrahman, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('flowi_test_');
    Hive.init(tempDir.path);

    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(ProjectCategoryAdapter());
    Hive.registerAdapter(ProjectCategoryModelAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(DateTimeAdapter());
    Hive.registerAdapter(IconAdapter());

    await Hive.openBox<ProjectModel>(Constants.kMainBox);
    await Hive.openBox(Constants.kSettingsBox);
  });

  testWidgets('app boots without hive init errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
