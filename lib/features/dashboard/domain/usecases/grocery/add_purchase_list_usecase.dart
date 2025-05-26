import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/purchase_repository.dart';

/// Use case for adding a new purchase list
class AddPurchaseListUsecase {
  /// The purchase list repository
  final PurchaseRepository repository;

  /// Creates a new AddPurchaseList use case
  AddPurchaseListUsecase(this.repository);

  /// Adds a new purchase list
  Future<Either<AppException, PurchaseList>> call(PurchaseList item) async {
    return repository.addPurchaseList(item);
  }
}
