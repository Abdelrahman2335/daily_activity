import 'dart:io';

import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/core/persistence/project_store.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

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

ProjectModel _project({required String id, String title = 'title'}) {
  return ProjectModel(
    id: id,
    title: title,
    description: 'desc',
    category: categories[ProjectCategory.work]!,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 2),
    tasks: [TaskModel(title: 'task')],
    status: TaskStatus.notStarted,
  );
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('flowi_project_store_');
    Hive.init(tempDir.path);
    _registerAdapters();
  });

  setUp(() async {
    if (Hive.isBoxOpen(Constants.kMainBox)) {
      await Hive.box<ProjectModel>(Constants.kMainBox).clear();
    } else {
      await ProjectStore.open();
    }
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('the app opens the main box through the store', () async {
    expect(Hive.isBoxOpen(Constants.kMainBox), isTrue);
    expect(ProjectStore.box.isOpen, isTrue);
    expect(ProjectStore.schemaVersion, greaterThanOrEqualTo(1));
  });

  test('readAll returns every project', () async {
    await ProjectStore.box.put('a', _project(id: 'a'));
    await ProjectStore.box.put('b', _project(id: 'b'));

    expect(ProjectStore.readAll().map((p) => p.id), ['a', 'b']);
  });

  test('readAll is empty for an empty box, not an error', () {
    expect(ProjectStore.readAll(), isEmpty);
  });

  test('readAll surfaces a closed box as an error to the caller', () async {
    await ProjectStore.box.close();
    expect(() => ProjectStore.readAll(), throwsA(isA<HiveError>()));

    await ProjectStore.open();
  });

  test('a box reopened at a higher version migrates and keeps its data',
      () async {
    const boxName = 'versionedBox';
    final projectsBox = await Hive.openBox<ProjectModel>(boxName);
    await projectsBox.put('p', _project(id: 'p'));
    final meta = await Hive.openBox('metaBox');
    // Written by an older release, before any version marker existed.
    expect(meta.get(Constants.kSchemaVersionKey), isNull);

    await ProjectStore.migrateIfNeeded(meta, projectsBox);

    expect(meta.get(Constants.kSchemaVersionKey), ProjectStore.schemaVersion);
    expect(projectsBox.get('p')?.id, 'p',
        reason: 'records must survive the migration');

    await projectsBox.deleteFromDisk();
    await meta.deleteFromDisk();
  });

  test('the migration runs once, not on every launch', () async {
    final projectsBox = await Hive.openBox<ProjectModel>('onceBox');
    final meta = await Hive.openBox('onceMetaBox');
    await ProjectStore.migrateIfNeeded(meta, projectsBox);
    await meta.put(Constants.kSchemaVersionKey, ProjectStore.schemaVersion);

    // A marker at the current version means no work on the next launch.
    await ProjectStore.migrateIfNeeded(meta, projectsBox);
    expect(meta.get(Constants.kSchemaVersionKey), ProjectStore.schemaVersion);

    await projectsBox.deleteFromDisk();
    await meta.deleteFromDisk();
  });

  test('a box from a newer app version is not migrated or destroyed',
      () async {
    final projectsBox = await Hive.openBox<ProjectModel>('futureBox');
    await projectsBox.put('p', _project(id: 'p'));
    final meta = await Hive.openBox('futureMetaBox');
    await meta.put(Constants.kSchemaVersionKey, ProjectStore.schemaVersion + 5);

    // Downgrade: skip the migration rather than clobber newer data.
    await ProjectStore.migrateIfNeeded(meta, projectsBox);

    expect(meta.get(Constants.kSchemaVersionKey),
        ProjectStore.schemaVersion + 5);
    expect(projectsBox.get('p')?.id, 'p');

    await projectsBox.deleteFromDisk();
    await meta.deleteFromDisk();
  });

  group('collectOrSkip', () {
    test('keeps readable records and skips the ones that throw', () {
      final result = ProjectStore.collectOrSkip<int>(
        ['good', 'broken', 'also-good'],
        (key) {
          if (key == 'broken') throw const FormatException('corrupt record');
          return 1;
        },
      );

      expect(result, [1, 1]);
    });

    test('ignores nulls', () {
      final result = ProjectStore.collectOrSkip<int>(
        ['a', 'b'],
        (key) => key == 'a' ? 7 : null,
      );

      expect(result, [7]);
    });

    test('an empty key set yields an empty list', () {
      expect(ProjectStore.collectOrSkip<int>([], (_) => 1), isEmpty);
    });
  });
}
