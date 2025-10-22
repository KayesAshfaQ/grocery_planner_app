import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for updating an existing purchase item
class UpdatePurchaseItemUsecase {
  /// The purchase repository
  final PurchaseRepository repository;

  /// Creates a new UpdatePurchaseItem use case
  UpdatePurchaseItemUsecase(this.repository);

  /// Updates an existing purchase item
  Future<Either<AppException, PurchaseItem>> call(PurchaseItem item) async {
    return repository.updatePurchaseItem(item);
  }
}
