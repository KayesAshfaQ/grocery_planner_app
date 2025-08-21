import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

/// Use case for retrieving purchase lists
class GetPurchaseListUsecase {
  /// The purchase repository
  final PurchaseRepository repository;

  /// Creates a new GetPurchaseList use case
  GetPurchaseListUsecase(this.repository);

  /// Gets all purchase lists
  Future<Either<AppException, List<PurchaseList>>> call() async {
    return repository.getPurchaseLists();
  }

  /// Gets purchase lists by their purchase status
  Future<Either<AppException, List<PurchaseList>>> byStatus(bool isPurchased) async {
    return repository.getPurchaseListsByStatus(isPurchased);
  }

  /// Gets a purchase list by its ID
  Future<Either<AppException, PurchaseList>> byId(String id) async {
    return repository.getPurchaseListById(id);
  }
}
