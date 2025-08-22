import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/features/settings/data/repository/setting_repo.dart';
import 'package:hive/hive.dart';

class SettingRepoImpl implements SettingRepo {
  final _box = Hive.box(Constants.kSettingsBox);
  @override
  bool loadTheme() {
    final isDarkMode = _box.get(Constants.themeKey, defaultValue: false);
    return isDarkMode;
  }

  @override
  void toggleTheme(bool value) async {
    await _box.put(Constants.themeKey, value);
  }

  @override
  String getUserName() {
    final userName = _box.get(Constants.userNameKey, defaultValue: "");
    return userName;
  }

  @override
  void updateUserName(String name) async {
    await _box.put(Constants.userNameKey, name);
  }
}
