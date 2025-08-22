part of 'setting_cubit.dart';

@immutable
sealed class SettingState {}

final class SettingInitial extends SettingState {}

final class SettingLoading extends SettingState {}

final class SettingSuccess extends SettingState {}

final class SettingError extends SettingState {
  SettingError(this.errMessage);
  final String errMessage;
}
