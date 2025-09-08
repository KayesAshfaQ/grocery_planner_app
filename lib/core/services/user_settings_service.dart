import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';
import 'package:grocery_planner_app/features/settings/domain/usecases/get_user_settings_usecase.dart';
import 'package:grocery_planner_app/features/settings/domain/usecases/update_default_currency_usecase.dart';

/// Simple service to provide easy access to user settings
/// This can be used across the app without needing BLoC
class UserSettingsService {
  final GetUserSettingsUsecase _getUserSettingsUsecase;
  final UpdateDefaultCurrencyUsecase _updateDefaultCurrencyUsecase;

  UserSettings? _cachedSettings;

  UserSettingsService({
    required GetUserSettingsUsecase getUserSettingsUsecase,
    required UpdateDefaultCurrencyUsecase updateDefaultCurrencyUsecase,
  })  : _getUserSettingsUsecase = getUserSettingsUsecase,
        _updateDefaultCurrencyUsecase = updateDefaultCurrencyUsecase;

  /// Get current default currency synchronously (uses cache or defaults)
  String get defaultCurrency {
    return _cachedSettings?.defaultCurrency ?? '\$';
  }

  /// Get current theme mode synchronously (uses cache or defaults)
  String get themeMode {
    return _cachedSettings?.themeMode ?? 'system';
  }

  /// Get current notifications enabled synchronously (uses cache or defaults)
  bool get notificationsEnabled {
    return _cachedSettings?.notificationsEnabled ?? true;
  }

  /// Initialize the service by loading settings
  Future<void> initialize() async {
    final result = await _getUserSettingsUsecase();
    result.fold(
      (exception) {
        // Use defaults if loading fails
        _cachedSettings = UserSettings.defaults();
      },
      (settings) {
        _cachedSettings = settings;
      },
    );
  }

  /// Update default currency
  Future<bool> updateDefaultCurrency(String currency) async {
    final result = await _updateDefaultCurrencyUsecase(currency);
    return result.fold(
      (exception) => false,
      (updatedCurrency) {
        // Update cache
        if (_cachedSettings != null) {
          _cachedSettings =
              _cachedSettings!.copyWith(defaultCurrency: updatedCurrency);
        }
        return true;
      },
    );
  }

  /// Get full settings asynchronously
  Future<UserSettings> getSettings() async {
    final result = await _getUserSettingsUsecase();
    return result.fold(
      (exception) => UserSettings.defaults(),
      (settings) {
        _cachedSettings = settings;
        return settings;
      },
    );
  }
}
