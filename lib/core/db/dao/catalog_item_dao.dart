import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/data/models/catalog_item_model.dart';

/// Data Access Object for CatalogItem operations
@dao
abstract class CatalogItemDao {
  /// Get all catalog items
  @Query('SELECT * FROM catalog_items ORDER BY name ASC')
  Future<List<CatalogItemModel>> getAllItems();

  /// Get a specific catalog item by ID
  @Query('SELECT * FROM catalog_items WHERE id = :id')
  Future<CatalogItemModel?> getItemById(String id);

  /// Insert a new catalog item
  @insert
  Future<void> insertItem(CatalogItemModel item);

  /// Update an existing catalog item
  @update
  Future<void> updateItem(CatalogItemModel item);

  /// Delete a catalog item
  @delete
  Future<void> deleteItem(CatalogItemModel item);

  /// Delete a catalog item by ID
  @Query('DELETE FROM catalog_items WHERE id = :id')
  Future<void> deleteItemById(String id);

  /// Search catalog items by name
  @Query('SELECT * FROM catalog_items WHERE name LIKE :query ORDER BY name ASC')
  Future<List<CatalogItemModel>> searchItemsByName(String query);

  /// Check if an item with the same name exists
  @Query('SELECT COUNT(*) FROM catalog_items WHERE name = :name')
  Future<int?> checkItemExists(String name);
}
