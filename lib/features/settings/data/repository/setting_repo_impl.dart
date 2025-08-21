import 'package:daily_activity/core/utils/constants.dart';
import 'package:daily_activity/features/settings/data/repository/setting_repo.dart';
import 'package:hive/hive.dart';

class SettingRepoImpl implements SettingRepo {
  @override
  bool loadTheme() {
    final box = Hive.box(Constants.kSettingsBox);
    final isDarkMode = box.get(Constants.themeKey, defaultValue: false);
    return isDarkMode;
  }

  @override
  void toggleTheme(bool value) {
    final box = Hive.box(Constants.kSettingsBox);
    box.put(Constants.themeKey, value);
  }

  @override
  void toggleNotification() {}
  @override
  void userImage() {}
}
