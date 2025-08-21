import 'package:daily_activity/features/settings/data/repository/setting_repo.dart';
import 'package:daily_activity/features/settings/data/repository/setting_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false) {
    loadTheme();
  }

  final SettingRepo _settingRepo = SettingRepoImpl();

  void loadTheme() {
    final isDark = _settingRepo.loadTheme();
    emit(isDark);
  }

  void toggleTheme() {
    final newValue = !state;
    _settingRepo.toggleTheme(newValue);
    emit(newValue);
  }
}
