import 'package:equatable/equatable.dart';

/// Entity representing user settings and preferences
class UserSettings extends Equatable {
  /// Default currency symbol for the user
  final String defaultCurrency;

  /// User's preferred language (for future internationalization)
  final String language;

  /// Whether to show notifications
  final bool notificationsEnabled;

  /// Theme preference (light, dark, system)
  final String themeMode;

  const UserSettings({
    required this.defaultCurrency,
    required this.language,
    required this.notificationsEnabled,
    required this.themeMode,
  });

  /// Default user settings
  factory UserSettings.defaults() {
    return const UserSettings(
      defaultCurrency: '\$',
      language: 'en',
      notificationsEnabled: true,
      themeMode: 'system',
    );
  }

  /// Create a copy with updated values
  UserSettings copyWith({
    String? defaultCurrency,
    String? language,
    bool? notificationsEnabled,
    String? themeMode,
  }) {
    return UserSettings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [
        defaultCurrency,
        language,
        notificationsEnabled,
        themeMode,
      ];
}
