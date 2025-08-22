import 'package:bloc/bloc.dart';
import 'package:daily_activity/core/utils/debug_logger.dart';
import 'package:daily_activity/features/settings/data/repository/setting_repo.dart';
import 'package:daily_activity/features/settings/data/repository/setting_repo_impl.dart';
import 'package:meta/meta.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial()) {
    loadTheme();
    getUserName();
  }
  final SettingRepo _settingRepo = SettingRepoImpl();

  bool _isDark = false;
  String _currentName = "";
  String get currentName => _currentName;
  bool get isDark => _isDark;

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

}
