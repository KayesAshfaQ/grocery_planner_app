import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';

/// Repository interface for grocery item operations
abstract class PurchaseRepository {
  /// Get all purchase lists
  Future<Either<AppException, List<PurchaseList>>> getPurchaseLists();

  /// Get purchase lists by their completion status
  Future<Either<AppException, List<PurchaseList>>> getPurchaseListsByStatus(bool isPurchased);

  /// Get a specific purchase list by ID
  Future<Either<AppException, PurchaseList>> getPurchaseListById(String id);

  /// Add a new purchase list
  Future<Either<AppException, PurchaseList>> addPurchaseList(PurchaseList item);

  /// Add a new purchase item
  Future<Either<AppException, PurchaseItem>> addPurchaseItem(PurchaseItem item);

  /// Update an existing purchase list
  Future<Either<AppException, PurchaseList>> updatePurchaseList(PurchaseList item);

  /// Delete a purchase list
  Future<Either<AppException, void>> deletePurchaseList(String id);

  /// Mark a purchase list as purchased with optional actual price
  Future<Either<AppException, PurchaseItem>> markItemAsPurchased(String id, {double? actualPrice});

  /// Get purchase lists by their category
  Future<Either<AppException, List<PurchaseItem>>> getPurchaseItemsByCategory(String category);
}
