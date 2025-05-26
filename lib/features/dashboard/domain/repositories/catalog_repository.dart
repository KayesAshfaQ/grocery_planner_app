import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';

/// Repository interface for catalog item operations
abstract class CatalogRepository {
  /// Get all catalog items
  Future<Either<AppException, List<CatalogItem>>> getCatalogItems();

  /// Get catalog items by category
  Future<Either<AppException, List<CatalogItem>>> getCatalogItemsByCategory(
      String category);

  /// Search catalog items by name
  Future<Either<AppException, List<CatalogItem>>> searchCatalogItems(
      String query);

  /// Get a specific catalog item by ID
  Future<Either<AppException, CatalogItem>> getCatalogItemById(String id);

  /// Add a new catalog item (typically used by administrators or for user-defined items)
  Future<Either<AppException, CatalogItem>> addCatalogItem(CatalogItem item);

  /// Update an existing catalog item
  Future<Either<AppException, CatalogItem>> updateCatalogItem(CatalogItem item);

  /// Delete a catalog item
  Future<Either<AppException, void>> deleteCatalogItem(String id);

}
