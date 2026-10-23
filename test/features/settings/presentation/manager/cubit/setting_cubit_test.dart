import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flowi/core/utils/constants.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('flowi_settings_test_');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    if (Hive.isBoxOpen(Constants.kSettingsBox)) {
      await Hive.box(Constants.kSettingsBox).clear();
    } else {
      await Hive.openBox(Constants.kSettingsBox);
    }
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  blocTest<SettingCubit, SettingState>(
    'toggleTheme emits success and flips mode',
    build: () => SettingCubit(),
    act: (cubit) => cubit.toggleTheme(),
    expect: () => [
      isA<SettingLoading>(),
      isA<SettingSuccess>(),
    ],
    verify: (cubit) {
      expect(cubit.isDark, isFalse);
    },
  );

  blocTest<SettingCubit, SettingState>(
    'updateUserName emits success and updates local name',
    build: () => SettingCubit(),
    act: (cubit) => cubit.updateUserName('Abdelrahman'),
    expect: () => [
      isA<SettingLoading>(),
      isA<SettingSuccess>(),
    ],
    verify: (cubit) {
      expect(cubit.currentName, 'Abdelrahman');
    },
  );

  blocTest<SettingCubit, SettingState>(
    'loadTheme emits error when settings box is closed',
    build: () => SettingCubit(),
    act: (cubit) async {
      await Hive.box(Constants.kSettingsBox).close();
      cubit.loadTheme();
    },
    expect: () => [
      isA<SettingLoading>(),
      isA<SettingError>().having(
          (s) => s.errMessage, 'message', 'Unexpected Error, Please try again later.'),
    ],
  );
}
