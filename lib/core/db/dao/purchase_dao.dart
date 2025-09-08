import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_item_model.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_list_model.dart';

/// Data Access Object for Purchase List and Item operations
@dao
abstract class PurchaseDao {
  /// Get all purchase lists
  @Query('SELECT * FROM purchase_lists ORDER BY created_at DESC')
  Future<List<PurchaseListModel>> getAllLists();

  /// Get a specific purchase list by ID
  @Query('SELECT * FROM purchase_lists WHERE id = :id')
  Future<PurchaseListModel?> getListById(int id);

  /// Insert a new purchase list
  @insert
  Future<void> insertList(PurchaseListModel item);

  /// Update an existing purchase list
  @update
  Future<void> updateList(PurchaseListModel item);

  /// Delete a purchase list
  @delete
  Future<void> deleteList(PurchaseListModel item);

  /// Delete a purchase list by ID
  @Query('DELETE FROM purchase_lists WHERE id = :id')
  Future<void> deleteListById(int id);

  /// Get all purchase items by list ID
  @Query(
      'SELECT * FROM purchase_list_items WHERE list_id = :listId ORDER BY id DESC')
  Future<List<PurchaseItemModel>> getAllItemsByListId(int listId);

  /// Get a specific purchase item by ID
  @Query('SELECT * FROM purchase_list_items WHERE id = :id')
  Future<PurchaseItemModel?> getItemById(int id);

  /// Insert a new purchase item
  @insert
  Future<void> insertItem(PurchaseItemModel item);

  /// Update an existing purchase item
  @update
  Future<void> updateItem(PurchaseItemModel item);

  /// Delete a purchase item
  @delete
  Future<void> deleteItem(PurchaseItemModel item);

  /// Delete a purchase item by ID
  @Query('DELETE FROM purchase_list_items WHERE id = :id')
  Future<void> deleteItemById(int id);
}
