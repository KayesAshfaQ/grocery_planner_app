import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for removing a purchase list
class RemovePurchaseListUsecase {
  /// The purchase list repository
  final PurchaseRepository repository;

  /// Creates a new RemovePurchaseList use case
  RemovePurchaseListUsecase(this.repository);

  /// Removes a purchase list
  Future<Either<AppException, void>> call(int id) async {
    return repository.deletePurchaseList(id);
  }
}
