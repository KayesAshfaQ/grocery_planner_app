import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';
import 'package:grocery_planner_app/features/settings/domain/repositories/settings_repository.dart';

/// Use case for updating user settings
class UpdateUserSettingsUsecase {
  final SettingsRepository repository;

  UpdateUserSettingsUsecase({required this.repository});

  Future<Either<AppException, UserSettings>> call(UserSettings settings) async {
    return await repository.updateUserSettings(settings);
  }
}
