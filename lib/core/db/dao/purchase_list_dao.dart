import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/dashboard/data/model/purchase_list_model.dart';

/// Data Access Object for GroceryItem operations
@dao
abstract class PurchaseListDao {
  /// Get all purchase lists
  @Query('SELECT * FROM purchase_lists ORDER BY createdAtMillis DESC')
  Future<List<PurchaseListModel>> getAllLists();

  /// Get a specific purchase list by ID
  @Query('SELECT * FROM purchase_lists WHERE id = :id')
  Future<PurchaseListModel?> getListById(String id);

  /// Insert a new purchase list
  @insert
  Future<void> insertItem(PurchaseListModel item);

  /// Update an existing purchase list
  @update
  Future<void> updateItem(PurchaseListModel item);

  /// Delete a purchase list
  @delete
  Future<void> deleteItem(PurchaseListModel item);

  /// Delete a purchase list by ID
  @Query('DELETE FROM purchase_lists WHERE id = :id')
  Future<void> deleteItemById(String id);
}
