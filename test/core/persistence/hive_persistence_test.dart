import 'dart:io';
import 'dart:typed_data';

// Hive does not expose a public binary writer, but these are marked
// @visibleForTesting in the package and let us reproduce records written by an
// older schema without hand-crafting Hive's wire format.
// ignore: implementation_imports
import 'package:hive/src/binary/binary_reader_impl.dart';
// ignore: implementation_imports
import 'package:hive/src/binary/binary_writer_impl.dart';
// ignore: implementation_imports
import 'package:hive/src/registry/type_registry_impl.dart';
import 'package:flowi/core/adapters/date_time_adapter.dart';
import 'package:flowi/core/adapters/icon_adapter.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
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

/// Encodes a Hive record body exactly like a generated adapter would, but only
/// for the given [fields]. Used to reproduce data written by an older schema.
Uint8List _encodeRecord(Map<int, dynamic> fields) {
  final writer = BinaryWriterImpl(TypeRegistryImpl());
  writer.writeByte(fields.length);
  fields.forEach((fieldId, value) {
    writer
      ..writeByte(fieldId)
      ..write(value);
  });
  return writer.toBytes();
}

/// A registry with every custom adapter, used to encode/decode records at the
/// byte level without a Hive box.
TypeRegistryImpl _fullRegistry() => TypeRegistryImpl()
  ..registerAdapter(ProjectCategoryModelAdapter())
  ..registerAdapter(TaskStatusAdapter())
  ..registerAdapter(TaskModelAdapter())
  ..registerAdapter(IconAdapter())
  ..registerAdapter(DateTimeAdapter());

ProjectModel _project({
  String id = 'p1',
  String title = 'title',
  List<TaskModel>? tasks,
  TaskStatus status = TaskStatus.inProgress,
}) {
  return ProjectModel(
    id: id,
    title: title,
    description: 'description',
    category: categories[ProjectCategory.finance]!,
    startDate: DateTime(2026, 3, 4, 10, 30),
    endDate: DateTime(2026, 3, 20, 18, 0),
    tasks: tasks ?? [TaskModel(id: 't1', title: 'task', isCompleted: true)],
    status: status,
    lastModified: DateTime(2026, 3, 5),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('flowi_hive_schema_');
    Hive.init(tempDir.path);
    _registerAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('adapter fingerprint', () {
    test('typeIds are stable (changing them makes existing data unreadable)',
        () {
      expect(ProjectModelAdapter().typeId, 0);
      expect(ProjectCategoryAdapter().typeId, 1);
      expect(TaskStatusAdapter().typeId, 2);
      expect(TaskModelAdapter().typeId, 3);
      expect(ProjectCategoryModelAdapter().typeId, 4);
      expect(IconAdapter().typeId, 5);
      expect(DateTimeAdapter().typeId, 6);
    });

    test('on-disk field layout of ProjectModel is unchanged', () {
      // Locks the HiveField ids written to disk. If this fails, existing users'
      // projects are read with the wrong mapping after an update.
      final registry = _fullRegistry();
      final writer = BinaryWriterImpl(registry);
      ProjectModelAdapter().write(writer, _project(id: 'schema'));

      final reader = BinaryReaderImpl(writer.toBytes(), registry);
      final fieldCount = reader.readByte();
      final fields = <int, dynamic>{
        for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
      };

      expect(fields.keys, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
      expect(fields[0], 'schema'); // id
      expect(fields[1], 'title'); // title
      expect(fields[6], TaskStatus.inProgress); // status
      expect((fields[7] as List).single, isA<TaskModel>()); // tasks
      expect(fields[8], DateTime(2026, 3, 5)); // lastModified
      // Reminder fields are an append-only extension (fields 9-11). Old
      // records written before them simply lack the entries and read back
      // as null; new writes always include them.
      expect(fields[9], isNull); // reminderMode
      expect(fields[10], isNull); // customSlots
      expect(fields[11], isNull); // customWeekdays
    });

    test('on-disk field layout of TaskModel is unchanged', () {
      final registry = _fullRegistry();
      final writer = BinaryWriterImpl(registry);
      TaskModelAdapter()
          .write(writer, TaskModel(id: 't1', title: 'task', isCompleted: true));

      final reader = BinaryReaderImpl(writer.toBytes(), registry);
      final fieldCount = reader.readByte();
      final fields = <int, dynamic>{
        for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
      };

      // 2 and 3 are gaps left by removed fields; never reuse them.
      expect(fields.keys, [0, 1, 4]);
      expect(fields[0], 't1');
      expect(fields[1], 'task');
      expect(fields[4], isTrue);
    });
  });

  group('round trip', () {
    test('ProjectModel survives a write/close/reopen cycle with nested data',
        () async {
      const boxName = 'roundTripBox';
      final original = _project();

      final box = await Hive.openBox<ProjectModel>(boxName);
      await box.put(original.id, original);
      await box.close();

      final reopened = await Hive.openBox<ProjectModel>(boxName);
      final loaded = reopened.get(original.id);

      expect(loaded, isNotNull);
      expect(loaded!.id, original.id);
      expect(loaded.title, original.title);
      expect(loaded.description, original.description);
      expect(loaded.status, original.status);
      expect(loaded.startDate, original.startDate);
      expect(loaded.endDate, original.endDate);
      expect(loaded.lastModified, original.lastModified);
      // Nested custom type (ProjectCategoryModel with an IconData)
      expect(loaded.category.title, original.category.title);
      expect(loaded.category.colorValue, original.category.colorValue);
      expect(loaded.category.icon.codePoint, original.category.icon.codePoint);
      // Nested list of custom types
      expect(loaded.tasks.single.id, original.tasks.single.id);
      expect(loaded.tasks.single.title, original.tasks.single.title);
      expect(loaded.tasks.single.isCompleted, isTrue);

      await reopened.deleteFromDisk();
    });

    test('main box data survives a restart of the app (close + reopen)',
        () async {
      final box = await Hive.openBox<ProjectModel>(Constants.kMainBox);
      await box.put('restart', _project(id: 'restart', title: 'survivor'));

      await box.close();
      final reopened = await Hive.openBox<ProjectModel>(Constants.kMainBox);

      expect(reopened.get('restart')?.title, 'survivor');
    });
  });

  group('data written by an older schema', () {
    test('TaskModel without id/isCompleted reads, but the id is regenerated',
        () async {
      // Written before TaskModel had HiveField(0) `id` and HiveField(4)
      // `isCompleted`. Only the title existed.
      final bytes = _encodeRecord({1: 'legacy task'});
      final registry = TypeRegistryImpl();

      final first = TaskModelAdapter().read(BinaryReaderImpl(bytes, registry));
      final second = TaskModelAdapter().read(BinaryReaderImpl(bytes, registry));

      expect(first.title, 'legacy task');
      expect(first.isCompleted, isFalse);
      expect(first.id, isNotNull);
      // Each read mints a new id: legacy tasks have no stable identity.
      expect(first.id, isNot(second.id));
    });

    test('a record without lastModified reads but resets it to "now"',
        () async {
      // ProjectModel before `lastModified` (HiveField(8)) was added. The record
      // still decodes, but the constructor defaults lastModified to
      // DateTime.now(), so old projects jump to the top of the "recent" sort.
      final registry = _fullRegistry();

      final writer = BinaryWriterImpl(registry);
      writer.writeByte(8);
      writer
        ..writeByte(0)
        ..write('legacy')
        ..writeByte(1)
        ..write('Legacy project')
        ..writeByte(2)
        ..write('written by v1')
        ..writeByte(3)
        ..write(categories[ProjectCategory.work]!)
        ..writeByte(4)
        ..write(DateTime(2025, 1, 1))
        ..writeByte(5)
        ..write(DateTime(2025, 1, 2))
        ..writeByte(6)
        ..write(TaskStatus.notStarted)
        ..writeByte(7)
        ..write(<TaskModel>[TaskModel(title: 'old task')]);

      final loaded =
          ProjectModelAdapter().read(BinaryReaderImpl(writer.toBytes(), registry));
      final readAt = DateTime.now();

      expect(loaded.title, 'Legacy project');
      expect(loaded.tasks.single.title, 'old task');
      expect(loaded.lastModified.isAfter(DateTime(2025, 1, 2)), isTrue);
      expect(
        readAt.difference(loaded.lastModified).inMinutes.abs(),
        lessThan(1),
      );
    });

    test('a record missing required fields throws (no migration path)',
        () async {
      // A v1 record that only had title/description. Every other field is
      // non-nullable in the adapter (`fields[3] as ProjectCategoryModel`, ...),
      // so decoding throws instead of degrading gracefully.
      final bytes = _encodeRecord({
        0: 'legacy',
        1: 'Legacy project',
        2: 'written by v1',
      });

      expect(
        () => ProjectModelAdapter()
            .read(BinaryReaderImpl(bytes, TypeRegistryImpl())),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('corrupted storage', () {
    test('a garbage box file is silently recovered, and the data is lost',
        () async {
      const boxName = 'corruptBox';
      final box = await Hive.openBox(boxName);
      await box.put('k', 'v');
      await box.close();

      final file = File(
          '${tempDir.path}${Platform.pathSeparator}$boxName.hive');
      expect(await file.exists(), isTrue);
      await file.writeAsString('this is not a hive database');

      // Hive logs "Recovering corrupted box." and opens an empty box: the user
      // gets no error, their projects are gone.
      final recovered = await Hive.openBox(boxName);
      expect(recovered.isEmpty, isTrue);
      await recovered.deleteFromDisk();
    });
  });
}
