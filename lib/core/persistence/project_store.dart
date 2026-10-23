import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/core/utils/debug_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// Single entry point for the projects box.
///
/// Everything that reads or writes `mainBox` goes through here so there is one
/// place to version the schema and one place where an undecodable record is
/// isolated instead of taking the whole box down with it.
///
/// Hive 2 has no built-in versioning, so the schema version is tracked in the
/// settings box (an untyped box, which can hold the int marker).
abstract final class ProjectStore {
  /// Version of the on-disk schema. Bump this whenever the Hive model changes
  /// and handle the old version in [migration].
  static const int schemaVersion = 1;

  /// The open box. Resolved on every access on purpose: a `Box` captured in a
  /// field goes stale as soon as the box is closed and reopened.
  static Box<ProjectModel> get box =>
      Hive.box<ProjectModel>(Constants.kMainBox);

  /// Opens the storage the app needs and applies pending migrations.
  static Future<void> open() async {
    final meta = await Hive.openBox(Constants.kSettingsBox);
    final projectsBox = await Hive.openBox<ProjectModel>(Constants.kMainBox);
    await migrateIfNeeded(meta, projectsBox);
  }

  @visibleForTesting
  static Future<void> migrateIfNeeded(
    Box meta,
    Box<ProjectModel> projectsBox,
  ) async {
    final storedValue = meta.get(Constants.kSchemaVersionKey);
    final storedVersion = storedValue is int ? storedValue : 0;

    if (storedVersion >= schemaVersion) return;

    await migration(projectsBox, storedVersion);
    await meta.put(Constants.kSchemaVersionKey, schemaVersion);
  }

  @visibleForTesting
  static Future<void> migration(Box box, int fromVersion) async {
    DebugLogger.log(
      'Migrating "${box.name}" from v$fromVersion to v$schemaVersion',
      tag: 'ProjectStore',
    );
    // Nothing older than v1 has ever been released, so there is nothing to
    // transform yet. When a field is added to ProjectModel/TaskModel:
    //  1. bump [schemaVersion],
    //  2. rewrite every record here so the new field is actually persisted
    //     (a record is only re-encoded when it is written back),
    //  3. cover it with a test in test/core/persistence/.
  }

  /// All decodable projects, in box order.
  ///
  /// A record that fails to decode is skipped instead of failing the whole
  /// read: one bad record must not empty the home screen.
  static List<ProjectModel> readAll() {
    final projectsBox = box;
    return collectOrSkip(projectsBox.keys, projectsBox.get);
  }

  /// Reads every [keys] entry with [read], skipping entries that throw or
  /// return null. Extracted so the isolation can be tested without planting
  /// undecodable bytes in a real box.
  @visibleForTesting
  static List<T> collectOrSkip<T>(
    Iterable<dynamic> keys,
    T? Function(dynamic key) read,
  ) {
    final values = <T>[];
    for (final key in keys) {
      try {
        final value = read(key);
        if (value != null) values.add(value);
      } catch (error) {
        DebugLogger.logError(
          'Skipping unreadable record "$key": $error',
          context: 'ProjectStore',
        );
      }
    }
    return values;
  }
}
