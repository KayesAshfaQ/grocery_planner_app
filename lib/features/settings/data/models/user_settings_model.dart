import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';

/// Data model for user settings with JSON serialization
class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required String defaultCurrency,
    required String language,
    required bool notificationsEnabled,
    required String themeMode,
  }) : super(
          defaultCurrency: defaultCurrency,
          language: language,
          notificationsEnabled: notificationsEnabled,
          themeMode: themeMode,
        );

  /// Create from entity
  factory UserSettingsModel.fromEntity(UserSettings entity) {
    return UserSettingsModel(
      defaultCurrency: entity.defaultCurrency,
      language: entity.language,
      notificationsEnabled: entity.notificationsEnabled,
      themeMode: entity.themeMode,
    );
  }

  /// Create from JSON
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      defaultCurrency: json['defaultCurrency'] ?? '\$',
      language: json['language'] ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      themeMode: json['themeMode'] ?? 'system',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'defaultCurrency': defaultCurrency,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'themeMode': themeMode,
    };
  }

  /// Create defaults
  factory UserSettingsModel.defaults() {
    return const UserSettingsModel(
      defaultCurrency: '\$',
      language: 'en',
      notificationsEnabled: true,
      themeMode: 'system',
    );
  }
}
