import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/settings/domain/repositories/settings_repository.dart';

/// Use case for updating default currency
class UpdateDefaultCurrencyUsecase {
  final SettingsRepository repository;

  UpdateDefaultCurrencyUsecase({required this.repository});

  Future<Either<AppException, String>> call(String currency) async {
    return await repository.updateDefaultCurrency(currency);
  }
}
