import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for adding a new purchase item
class AddPurchaseItemUsecase {
  /// The purchase item repository
  final PurchaseRepository repository;

  /// Creates a new AddPurchaseItem use case
  AddPurchaseItemUsecase(this.repository);

  /// Adds a new purchase item
  Future<Either<AppException, PurchaseItem>> call(PurchaseItem item) async {
    return repository.addPurchaseItem(item);
  }
}
