import 'package:floor/floor.dart';
import 'package:grocery_planner_app/core/db/dao/models/category_spending_model.dart';
import 'package:grocery_planner_app/features/home/data/models/grocery_item_model.dart';

/// Data Access Object for GroceryItem operations
@dao
abstract class GroceryItemDao {
  /// Get all grocery items
  @Query('SELECT * FROM grocery_items ORDER BY createdAtMillis DESC')
  Future<List<GroceryItemModel>> getAllItems();

  /// Get grocery items by purchase status
  @Query(
      'SELECT * FROM grocery_items WHERE isPurchased = :isPurchased ORDER BY createdAtMillis DESC')
  Future<List<GroceryItemModel>> getItemsByStatus(bool isPurchased);

  /// Get a specific grocery item by ID
  @Query('SELECT * FROM grocery_items WHERE id = :id')
  Future<GroceryItemModel?> getItemById(String id);

  /// Insert a new grocery item
  @insert
  Future<void> insertItem(GroceryItemModel item);

  /// Update an existing grocery item
  @update
  Future<void> updateItem(GroceryItemModel item);

  /// Delete a grocery item
  @delete
  Future<void> deleteItem(GroceryItemModel item);

  /// Delete a grocery item by ID
  @Query('DELETE FROM grocery_items WHERE id = :id')
  Future<void> deleteItemById(String id);

  /// Get grocery items by category
  @Query(
      'SELECT * FROM grocery_items WHERE category = :category ORDER BY createdAtMillis DESC')
  Future<List<GroceryItemModel>> getItemsByCategory(String category);

  /// Get grocery items within a date range
  @Query(
      'SELECT * FROM grocery_items WHERE createdAtMillis BETWEEN :startMillis AND :endMillis')
  Future<List<GroceryItemModel>> getItemsByDateRange(int startMillis, int endMillis);

  /// Get total spending by category within a date range
  @Query('''
    SELECT category, SUM(CASE WHEN purchasedPrice IS NOT NULL THEN purchasedPrice ELSE unitPrice * quantity END) as value
    FROM grocery_items
    WHERE isPurchased = 1 AND purchasedAtMillis BETWEEN :startMillis AND :endMillis
    GROUP BY category
  ''')
  Future<List<CategorySpendingModel>> getTotalSpendingByCategory(
      int startMillis, int endMillis);
}
