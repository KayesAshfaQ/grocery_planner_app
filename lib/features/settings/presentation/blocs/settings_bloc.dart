import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/settings/domain/usecases/get_user_settings_usecase.dart';
import 'package:grocery_planner_app/features/settings/domain/usecases/update_default_currency_usecase.dart';
import 'package:grocery_planner_app/features/settings/domain/usecases/update_user_settings_usecase.dart';
import 'package:grocery_planner_app/features/settings/presentation/blocs/settings_event.dart';
import 'package:grocery_planner_app/features/settings/presentation/blocs/settings_state.dart';

/// BLoC for managing user settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetUserSettingsUsecase getUserSettingsUsecase;
  final UpdateUserSettingsUsecase updateUserSettingsUsecase;
  final UpdateDefaultCurrencyUsecase updateDefaultCurrencyUsecase;

  SettingsBloc({
    required this.getUserSettingsUsecase,
    required this.updateUserSettingsUsecase,
    required this.updateDefaultCurrencyUsecase,
  }) : super(SettingsInitialState()) {
    on<LoadUserSettingsEvent>(_onLoadUserSettings);
    on<UpdateUserSettingsEvent>(_onUpdateUserSettings);
    on<UpdateDefaultCurrencyEvent>(_onUpdateDefaultCurrency);
  }

  Future<void> _onLoadUserSettings(
    LoadUserSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    final result = await getUserSettingsUsecase();
    result.fold(
      (exception) => emit(SettingsErrorState(message: exception.message)),
      (settings) => emit(SettingsLoadedState(settings: settings)),
    );
  }

  Future<void> _onUpdateUserSettings(
    UpdateUserSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    final result = await updateUserSettingsUsecase(event.settings);
    result.fold(
      (exception) => emit(SettingsErrorState(message: exception.message)),
      (settings) => emit(SettingsUpdatedState(settings: settings)),
    );
  }

  Future<void> _onUpdateDefaultCurrency(
    UpdateDefaultCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Get current settings first
    final currentResult = await getUserSettingsUsecase();
    currentResult.fold(
      (exception) => emit(SettingsErrorState(message: exception.message)),
      (currentSettings) async {
        // Update only the currency
        final result = await updateDefaultCurrencyUsecase(event.currency);
        result.fold(
          (exception) => emit(SettingsErrorState(message: exception.message)),
          (currency) {
            final updatedSettings =
                currentSettings.copyWith(defaultCurrency: currency);
            emit(SettingsUpdatedState(settings: updatedSettings));
          },
        );
      },
    );
  }
}
