import 'package:flowi/core/models/reminder_config.dart';

abstract class SettingRepo {
  bool loadTheme();
  void toggleTheme(bool value);
  String getUserName();
  void updateUserName(String name);
  GlobalReminderConfig loadReminderConfig();
  void saveReminderConfig(GlobalReminderConfig config);
}
