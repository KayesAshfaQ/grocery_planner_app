import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for updating an existing purchase list
class UpdatePurchaseListUsecase {
  /// The purchase repository
  final PurchaseRepository repository;

  /// Creates a new UpdatePurchaseList use case
  UpdatePurchaseListUsecase(this.repository);

  /// Updates an existing purchase list
  Future<Either<AppException, PurchaseList>> call(PurchaseList list) async {
    return repository.updatePurchaseList(list);
  }
}
