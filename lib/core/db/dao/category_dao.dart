import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/dashboard/data/model/category_model.dart';

/// Data Access Object for Catalog operations
@dao
abstract class CategoryDao {
  /// Get all category items
  @Query('SELECT * FROM category ORDER BY name ASC')
  Future<List<CategoryModel>> getAllItems();

  /// Get a specific category item by ID
  @Query('SELECT * FROM category WHERE id = :id')
  Future<CategoryModel?> getItemById(String id);

  /// Insert a new category item
  @insert
  Future<void> insertItem(CategoryModel item);

  /// Update an existing category item
  @update
  Future<void> updateItem(CategoryModel item);

  /// Delete a category item
  @delete
  Future<void> deleteItem(CategoryModel item);

  /// Delete a category item by ID
  @Query('DELETE FROM category WHERE id = :id')
  Future<void> deleteItemById(String id);

  /// Get category items by category
  @Query('SELECT * FROM category WHERE category = :category ORDER BY name ASC')
  Future<List<CategoryModel>> getItemsByCategory(String category);

  /// Search category items by name
  @Query('SELECT * FROM category WHERE name LIKE :query ORDER BY name ASC')
  Future<List<CategoryModel>> searchItemsByName(String query);

  /// Get all distinct categories
  @Query('SELECT DISTINCT category FROM category ORDER BY category ASC')
  Future<List<String>> getAllCategories();

  /// Check if an item with the same name exists
  @Query('SELECT COUNT(*) FROM category WHERE name = :name')
  Future<int?> checkItemExists(String name);
}
