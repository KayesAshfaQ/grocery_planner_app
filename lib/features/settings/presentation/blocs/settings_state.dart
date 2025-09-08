import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';

/// States for Settings BLoC
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

/// Initial state
class SettingsInitialState extends SettingsState {}

/// Loading state
class SettingsLoadingState extends SettingsState {}

/// Settings loaded successfully
class SettingsLoadedState extends SettingsState {
  final UserSettings settings;

  const SettingsLoadedState({required this.settings});

  @override
  List<Object> get props => [settings];
}

/// Error state
class SettingsErrorState extends SettingsState {
  final String message;

  const SettingsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

/// Settings updated successfully
class SettingsUpdatedState extends SettingsState {
  final UserSettings settings;

  const SettingsUpdatedState({required this.settings});

  @override
  List<Object> get props => [settings];
}
