import 'dart:io';

import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/features/project/data/project_repository/project_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

ProjectModel _project({
  required String id,
  String title = 'title',
  String description = 'desc',
}) {
  return ProjectModel(
    id: id,
    title: title,
    description: description,
    category: categories[ProjectCategory.work]!,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 3),
    tasks: [TaskModel(title: 't1')],
    status: TaskStatus.notStarted,
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
    tempDir = await Directory.systemTemp.createTemp('flowi_project_repo_test_');
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

  test('addProject returns Right and writes to box', () async {
    final repo = ProjectRepositoryImpl();
    final project = _project(id: 'p1');
    final result = await repo.addProject(project: project);

    expect(result.isRight(), isTrue);
    final loaded = Hive.box<ProjectModel>(Constants.kMainBox).get('p1');
    expect(loaded?.title, 'title');
  });

  test('editProject returns Left when project does not exist', () async {
    final repo = ProjectRepositoryImpl();
    final result = await repo.editProject(updatedProject: _project(id: 'missing'));
    expect(result.isLeft(), isTrue);
    result.fold((err) => expect(err, 'Project not found for updating'), (_) {
      fail('Expected Left');
    });
  });

  test('editProject returns Right when existing project is updated', () async {
    final repo = ProjectRepositoryImpl();
    await repo.addProject(project: _project(id: 'p2', title: 'old'));
    final updated = _project(id: 'p2', title: 'new');

    final result = await repo.editProject(updatedProject: updated);
    expect(result.isRight(), isTrue);
    expect(Hive.box<ProjectModel>(Constants.kMainBox).get('p2')?.title, 'new');
  });

  test('deleteProject returns Right and removes entry', () async {
    final repo = ProjectRepositoryImpl();
    await repo.addProject(project: _project(id: 'p3'));

    final result = await repo.deleteProject(projectId: 'p3');
    expect(result.isRight(), isTrue);
    expect(Hive.box<ProjectModel>(Constants.kMainBox).containsKey('p3'), isFalse);
  });

  test('deleteProject returns Left when box is closed', () async {
    final repo = ProjectRepositoryImpl();
    await Hive.box<ProjectModel>(Constants.kMainBox).close();

    final result = await repo.deleteProject(projectId: 'p3');
    expect(result.isLeft(), isTrue);

    await Hive.openBox<ProjectModel>(Constants.kMainBox);
  });

  test('data written by the repository survives a close/reopen cycle', () async {
    final repo = ProjectRepositoryImpl();
    await repo.addProject(project: _project(id: 'persist', title: 'survivor'));

    await Hive.box<ProjectModel>(Constants.kMainBox).close();
    await Hive.openBox<ProjectModel>(Constants.kMainBox);

    // A fresh repository instance, as after an app restart.
    final reopened = Hive.box<ProjectModel>(Constants.kMainBox)
        .get('persist');
    expect(reopened?.title, 'survivor');
  });

  test('nested project data round-trips through the repository', () async {
    final repo = ProjectRepositoryImpl();
    final original = ProjectModel(
      id: 'nested',
      title: 'nested',
      description: 'desc',
      category: categories[ProjectCategory.finance]!,
      startDate: DateTime(2026, 2, 3, 9, 15),
      endDate: DateTime(2026, 2, 10, 17, 45),
      tasks: [
        TaskModel(id: 't1', title: 'first', isCompleted: true),
        TaskModel(id: 't2', title: 'second', isCompleted: false),
      ],
      status: TaskStatus.inProgress,
    );

    await repo.addProject(project: original);
    await Hive.box<ProjectModel>(Constants.kMainBox).close();
    await Hive.openBox<ProjectModel>(Constants.kMainBox);

    final loaded =
        Hive.box<ProjectModel>(Constants.kMainBox).get(original.id)!;
    expect(loaded.category.title, original.category.title);
    expect(loaded.category.icon.codePoint, original.category.icon.codePoint);
    expect(loaded.startDate, original.startDate);
    expect(loaded.endDate, original.endDate);
    expect(loaded.tasks.map((t) => t.id), ['t1', 't2']);
    expect(loaded.tasks.map((t) => t.isCompleted), [true, false]);
  });

  test('addProject rejects a duplicate id instead of overwriting', () async {
    final repo = ProjectRepositoryImpl();
    await repo.addProject(project: _project(id: 'dup', title: 'first'));
    final result =
        await repo.addProject(project: _project(id: 'dup', title: 'second'));

    expect(result.isLeft(), isTrue);
    result.fold(
      (err) => expect(err, contains('already exists')),
      (_) => fail('Expected Left'),
    );
    final box = Hive.box<ProjectModel>(Constants.kMainBox);
    expect(box.length, 1);
    expect(box.get('dup')?.title, 'first');
  });

  test('deleteProject returns Left for an id that does not exist', () async {
    final repo = ProjectRepositoryImpl();

    final result = await repo.deleteProject(projectId: 'never-existed');

    // Previously reported success, so the UI said "deleted" for a no-op.
    expect(result.isLeft(), isTrue);
    result.fold(
      (err) => expect(err, 'Project not found for deleting'),
      (_) => fail('Expected Left'),
    );
  });

  test('constructing the repository is safe before the box is opened', () async {
    await Hive.box<ProjectModel>(Constants.kMainBox).close();

    // The box is resolved per call, so construction never throws...
    final repo = ProjectRepositoryImpl();

    // ...and calls fail cleanly instead of crashing.
    final result = await repo.deleteProject(projectId: 'p1');
    expect(result.isLeft(), isTrue);

    await Hive.openBox<ProjectModel>(Constants.kMainBox);
  });

  test('a reopened box is used by the same repository instance', () async {
    final repo = ProjectRepositoryImpl();
    await repo.addProject(project: _project(id: 'stale'));

    await Hive.box<ProjectModel>(Constants.kMainBox).close();
    await Hive.openBox<ProjectModel>(Constants.kMainBox);

    // A Box held in a field would throw "Box has already been closed" here.
    final result = await repo.deleteProject(projectId: 'stale');
    expect(result.isRight(), isTrue);
  });
}
