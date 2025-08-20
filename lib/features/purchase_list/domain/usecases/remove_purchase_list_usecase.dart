import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for adding a new purchase list
class RemovePurchaseListUsecase {
  /// The purchase list repository
  final PurchaseRepository repository;

  /// Creates a new AddPurchaseList use case
  RemovePurchaseListUsecase(this.repository);

  /// Adds a new purchase list
  Future<Either<AppException, PurchaseList>> call(PurchaseList item) async {
    return repository.addPurchaseList(item);
  }
}
