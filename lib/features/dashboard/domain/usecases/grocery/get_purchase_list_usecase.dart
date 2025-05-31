import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/purchase_repository.dart';

/// Use case for retrieving purchase lists
class GetAllPurchaseListUsecase {
  /// The purchase repository
  final PurchaseRepository repository;

  /// Creates a new GetPurchaseList use case
  GetAllPurchaseListUsecase(this.repository);

  /// Gets all purchase lists
  Future<Either<AppException, List<PurchaseList>>> call() async {
    return repository.getPurchaseLists();
  }

  /// Gets purchase lists by their purchase status
  Future<Either<AppException, List<PurchaseList>>> byStatus(bool isPurchased) async {
    return repository.getPurchaseListsByStatus(isPurchased);
  }
}
