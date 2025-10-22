import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for adding a new purchase item
class RemovePurchaseItemUsecase {
  /// The purchase item repository
  final PurchaseRepository repository;

  /// Creates a new AddPurchaseItem use case
  RemovePurchaseItemUsecase(this.repository);

  /// Adds a new purchase item
  Future<Either<AppException, void>> call(int id) async {
    return repository.removePurchaseItem(id);
  }
}
