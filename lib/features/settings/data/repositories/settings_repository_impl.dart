import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/settings/data/datasources/local/settings_local_data_source.dart';
import 'package:grocery_planner_app/features/settings/data/models/user_settings_model.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';
import 'package:grocery_planner_app/features/settings/domain/repositories/settings_repository.dart';

/// Implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<AppException, UserSettings>> getUserSettings() async {
    try {
      final result = await localDataSource.getUserSettings();
      return Right(result);
    } catch (error) {
      return Left(AppException(
          message: 'Failed to load settings: ${error.toString()}'));
    }
  }

  @override
  Future<Either<AppException, UserSettings>> updateUserSettings(
      UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      await localDataSource.saveUserSettings(model);
      return Right(settings);
    } catch (error) {
      return Left(AppException(
          message: 'Failed to update settings: ${error.toString()}'));
    }
  }

  @override
  Future<Either<AppException, String>> updateDefaultCurrency(
      String currency) async {
    try {
      await localDataSource.updateDefaultCurrency(currency);
      return Right(currency);
    } catch (error) {
      return Left(AppException(
          message: 'Failed to update currency: ${error.toString()}'));
    }
  }

  @override
  Future<Either<AppException, String>> updateThemeMode(String themeMode) async {
    try {
      await localDataSource.updateThemeMode(themeMode);
      return Right(themeMode);
    } catch (error) {
      return Left(
          AppException(message: 'Failed to update theme: ${error.toString()}'));
    }
  }

  @override
  Future<Either<AppException, bool>> updateNotificationsEnabled(
      bool enabled) async {
    try {
      await localDataSource.updateNotificationsEnabled(enabled);
      return Right(enabled);
    } catch (error) {
      return Left(AppException(
          message: 'Failed to update notifications: ${error.toString()}'));
    }
  }
}
