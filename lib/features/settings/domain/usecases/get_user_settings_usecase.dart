import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/settings/domain/entities/user_settings.dart';
import 'package:grocery_planner_app/features/settings/domain/repositories/settings_repository.dart';

/// Use case for getting user settings
class GetUserSettingsUsecase {
  final SettingsRepository repository;

  GetUserSettingsUsecase({required this.repository});

  Future<Either<AppException, UserSettings>> call() async {
    return await repository.getUserSettings();
  }
}
