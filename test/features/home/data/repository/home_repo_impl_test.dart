import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/features/home/data/repository/home_repo_impl.dart';
import 'package:flowi/features/project/data/project_repository/project_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

ProjectModel _project({
  required String id,
  required List<TaskModel> tasks,
  required TaskStatus status,
  DateTime? lastModified,
}) {
  return ProjectModel(
    id: id,
    title: id,
    description: 'desc',
    category: categories[ProjectCategory.work]!,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 10),
    tasks: tasks,
    status: status,
    lastModified: lastModified,
  );
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProjectModelAdapter());
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProjectCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskStatusAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(TaskModelAdapter());
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(ProjectCategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(IconAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(DateTimeAdapter());
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('flowi_home_repo_test_');
    Hive.init(tempDir.path);
    _registerAdapters();
  });

  setUp(() async {
    if (Hive.isBoxOpen(Constants.kMainBox)) {
      await Hive.box<ProjectModel>(Constants.kMainBox).clear();
    } else {
      await Hive.openBox<ProjectModel>(Constants.kMainBox);
    }
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('getProjects returns Right with sorted projects', () async {
    final box = Hive.box<ProjectModel>(Constants.kMainBox);
    final oldProject = _project(
      id: 'old',
      tasks: [TaskModel(title: 't1')],
      status: TaskStatus.notStarted,
      lastModified: DateTime(2026, 1, 1),
    );
    final newProject = _project(
      id: 'new',
      tasks: [TaskModel(title: 't2')],
      status: TaskStatus.inProgress,
      lastModified: DateTime(2026, 1, 3),
    );
    await box.put(oldProject.id, oldProject);
    await box.put(newProject.id, newProject);

    final repo = HomeRepoImpl();
    final result = repo.getProjects();

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('Expected Right'),
      (projects) => expect(projects.first.id, 'new'),
    );
  });

  test('dateFilter returns Left when main box is unavailable', () async {
    await Hive.box<ProjectModel>(Constants.kMainBox).close();
    final repo = HomeRepoImpl();
    final result = repo.dateFilter(DateTime(2026, 1, 1));
    expect(result, isA<Left<String, List<ProjectModel>>>());
    await Hive.openBox<ProjectModel>(Constants.kMainBox);
  });

  test('getOverallProgress handles no tasks / 0% / 100%', () async {
    final box = Hive.box<ProjectModel>(Constants.kMainBox);
    final repo = HomeRepoImpl();

    expect(repo.getOverallProgress(), '0');

    final zero = _project(
      id: 'zero',
      tasks: [TaskModel(title: 'a', isCompleted: false)],
      status: TaskStatus.notStarted,
    );
    await box.put(zero.id, zero);
    expect(repo.getOverallProgress(), '0');

    final full = _project(
      id: 'full',
      tasks: [TaskModel(title: 'b', isCompleted: true)],
      status: TaskStatus.completed,
    );
    await box.put(full.id, full);
    expect(repo.getOverallProgress(), '50');

    await box.delete(zero.id);
    expect(repo.getOverallProgress(), '100');
  });

  test('progressValue returns 0%, 100%, and 0% for no tasks', () {
    final repo = HomeRepoImpl();
    final none = _project(
      id: 'none',
      tasks: const [],
      status: TaskStatus.notStarted,
    );
    final done = _project(
      id: 'done',
      tasks: [TaskModel(title: 'a', isCompleted: true)],
      status: TaskStatus.completed,
    );
    final zero = _project(
      id: 'zero',
      tasks: [TaskModel(title: 'a', isCompleted: false)],
      status: TaskStatus.notStarted,
    );

    expect(repo.progressValue(none), '0%');
    expect(repo.progressValue(done), '100%');
    expect(repo.progressValue(zero), '0%');
  });

  test('an empty box is a valid state, not an error', () {
    final repo = HomeRepoImpl();

    final projects = repo.getProjects();
    expect(projects.isRight(), isTrue);
    projects.fold(
      (err) => fail('Expected empty list, got $err'),
      (list) => expect(list, isEmpty),
    );
    expect(repo.dateTimeList(), isEmpty);
    expect(repo.statusFilter(TaskStatus.completed).isRight(), isTrue);
    expect(repo.getOverallProgress(), '0');
    expect(repo.dateFilter(DateTime(2026, 1, 5)).isRight(), isTrue);
  });

  test('data written through the project repository is visible here', () async {
    final writer = ProjectRepositoryImpl();
    final project = _project(
      id: 'shared',
      tasks: [TaskModel(title: 'a', isCompleted: true)],
      status: TaskStatus.completed,
      lastModified: DateTime(2026, 1, 2),
    );
    await writer.addProject(project: project);

    final repo = HomeRepoImpl();
    final result = repo.getProjects();

    result.fold(
      (err) => fail('Expected Right, got $err'),
      (projects) => expect(projects.single.id, 'shared'),
    );
  });

  test('dateTimeList spans the full range between the earliest and latest date',
      () async {
    final box = Hive.box<ProjectModel>(Constants.kMainBox);
    final short = ProjectModel(
      id: 'short',
      title: 'short',
      description: 'd',
      category: categories[ProjectCategory.work]!,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 3),
      tasks: const [],
      status: TaskStatus.notStarted,
    );
    await box.put(short.id, short);

    expect(HomeRepoImpl().dateTimeList(), [
      DateTime(2026, 1, 1),
      DateTime(2026, 1, 2),
      DateTime(2026, 1, 3),
    ]);
  });
}
