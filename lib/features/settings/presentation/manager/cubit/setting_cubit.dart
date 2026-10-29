import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flowi/core/models/reminder_config.dart';
import 'package:flowi/core/services/notification_service.dart';
import 'package:flowi/core/utils/debug_logger.dart';
import 'package:flowi/features/settings/data/repository/setting_repo.dart';
import 'package:flowi/features/settings/data/repository/setting_repo_impl.dart';
import 'package:meta/meta.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial()) {
    loadTheme();
    getUserName();
    loadGlobalReminderConfig();
  }
  final SettingRepo _settingRepo = SettingRepoImpl();

  bool _isDark = false;
  String _currentName = "";
  GlobalReminderConfig _reminderConfig = GlobalReminderConfig.defaults;
  String get currentName => _currentName;
  bool get isDark => _isDark;
  GlobalReminderConfig get reminderConfig => _reminderConfig;

  void loadTheme() {
    emit(SettingLoading());
    try {
      _isDark = _settingRepo.loadTheme();
      emit(SettingSuccess());
    } catch (error) {
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log("Unexpected Error in the toggleTheme, Error: $error");
    }
  }

  void toggleTheme() {
    emit(SettingLoading());

    try {
      _isDark = !_isDark;
      _settingRepo.toggleTheme(_isDark);
      emit(SettingSuccess());
    } catch (error) {
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log("Unexpected Error in the toggleTheme, Error: $error");
    }
  }

  void getUserName() {
    emit(SettingLoading());

    try {
      _currentName = _settingRepo.getUserName();
      emit(SettingSuccess());
    } catch (error) {
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log("Unexpected Error in the toggleTheme, Error: $error");
    }
  }

  void updateUserName(String newName) {
    emit(SettingLoading());

    try {
      _settingRepo.updateUserName(newName);
      _currentName = newName;
      emit(SettingSuccess());
    } catch (error) {
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log("Unexpected Error in updateUserName, Error: $error");
    }
  }

  /// Reads the global reminder configuration from the settings box.
  void loadGlobalReminderConfig() {
    emit(SettingLoading());

    try {
      _reminderConfig = _settingRepo.loadReminderConfig();
      emit(SettingSuccess());
    } catch (error) {
      _reminderConfig = GlobalReminderConfig.defaults;
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log(
          "Unexpected Error in loadGlobalReminderConfig, Error: $error");
    }
  }

  /// Persists a new global reminder configuration and re-aligns the
  /// notification schedule. The resync is fire-and-forget: plugin failures
  /// never block the UI, the setting itself is already committed.
  void updateReminderConfig(GlobalReminderConfig config) {
    emit(SettingLoading());

    try {
      _reminderConfig = config;
      _settingRepo.saveReminderConfig(config);
      emit(SettingSuccess());
      if (NotificationService.instance.isReady) {
        unawaited(NotificationService.instance.resync());
      }
    } catch (error) {
      emit(SettingError("Unexpected Error, Please try again later."));
      DebugLogger.log(
          "Unexpected Error in updateReminderConfig, Error: $error");
    }
  }
}
