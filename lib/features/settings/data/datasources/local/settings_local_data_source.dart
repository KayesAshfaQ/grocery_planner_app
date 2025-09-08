import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_planner_app/features/settings/data/models/user_settings_model.dart';

/// Local data source for user settings using SharedPreferences
abstract class SettingsLocalDataSource {
  Future<UserSettingsModel> getUserSettings();
  Future<void> saveUserSettings(UserSettingsModel settings);
  Future<void> updateDefaultCurrency(String currency);
  Future<void> updateThemeMode(String themeMode);
  Future<void> updateNotificationsEnabled(bool enabled);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _userSettingsKey = 'user_settings';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserSettingsModel> getUserSettings() async {
    final jsonString = sharedPreferences.getString(_userSettingsKey);
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserSettingsModel.fromJson(json);
    } else {
      // Return defaults if no settings found
      return UserSettingsModel.defaults();
    }
  }

  @override
  Future<void> saveUserSettings(UserSettingsModel settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await sharedPreferences.setString(_userSettingsKey, jsonString);
  }

  @override
  Future<void> updateDefaultCurrency(String currency) async {
    final currentSettings = await getUserSettings();
    final updatedSettings = UserSettingsModel(
      defaultCurrency: currency,
      language: currentSettings.language,
      notificationsEnabled: currentSettings.notificationsEnabled,
      themeMode: currentSettings.themeMode,
    );
    await saveUserSettings(updatedSettings);
  }

  @override
  Future<void> updateThemeMode(String themeMode) async {
    final currentSettings = await getUserSettings();
    final updatedSettings = UserSettingsModel(
      defaultCurrency: currentSettings.defaultCurrency,
      language: currentSettings.language,
      notificationsEnabled: currentSettings.notificationsEnabled,
      themeMode: themeMode,
    );
    await saveUserSettings(updatedSettings);
  }

  @override
  Future<void> updateNotificationsEnabled(bool enabled) async {
    final currentSettings = await getUserSettings();
    final updatedSettings = UserSettingsModel(
      defaultCurrency: currentSettings.defaultCurrency,
      language: currentSettings.language,
      notificationsEnabled: enabled,
      themeMode: currentSettings.themeMode,
    );
    await saveUserSettings(updatedSettings);
  }
}
