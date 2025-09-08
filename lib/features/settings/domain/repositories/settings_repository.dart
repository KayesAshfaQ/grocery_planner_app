import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';

/// Repository interface for managing user settings
abstract class SettingsRepository {
  /// Get current user settings
  Future<Either<AppException, UserSettings>> getUserSettings();

  /// Update user settings
  Future<Either<AppException, UserSettings>> updateUserSettings(
      UserSettings settings);

  /// Update only the default currency
  Future<Either<AppException, String>> updateDefaultCurrency(String currency);

  /// Update theme mode
  Future<Either<AppException, String>> updateThemeMode(String themeMode);

  /// Update notifications preference
  Future<Either<AppException, bool>> updateNotificationsEnabled(bool enabled);
}
