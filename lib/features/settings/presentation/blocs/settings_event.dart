import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';

/// Events for Settings BLoC
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

/// Load user settings
class LoadUserSettingsEvent extends SettingsEvent {}

/// Update full user settings
class UpdateUserSettingsEvent extends SettingsEvent {
  final UserSettings settings;

  const UpdateUserSettingsEvent({required this.settings});

  @override
  List<Object> get props => [settings];
}

/// Update only default currency
class UpdateDefaultCurrencyEvent extends SettingsEvent {
  final String currency;

  const UpdateDefaultCurrencyEvent({required this.currency});

  @override
  List<Object> get props => [currency];
}

/// Update theme mode
class UpdateThemeModeEvent extends SettingsEvent {
  final String themeMode;

  const UpdateThemeModeEvent({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

/// Update notifications enabled
class UpdateNotificationsEnabledEvent extends SettingsEvent {
  final bool enabled;

  const UpdateNotificationsEnabledEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}
