import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/data/models/category_model.dart';

/// Data Access Object for Catalog operations
@dao
abstract class CategoryDao {
  /// Get all category items
  @Query('SELECT * FROM categories ORDER BY name ASC')
  Future<List<CategoryModel>> getAllItems();

  /// Get a specific category item by ID
  @Query('SELECT * FROM categories WHERE id = :id')
  Future<CategoryModel?> getItemById(int id);

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
  @Query('DELETE FROM categories WHERE id = :id')
  Future<void> deleteItemById(int id);

  /// Get category items by category
  @Query(
      'SELECT * FROM categories WHERE category = :category ORDER BY name ASC')
  Future<List<CategoryModel>> getItemsByCategory(String category);

  /// Search category items by name
  @Query('SELECT * FROM categories WHERE name LIKE :query ORDER BY name ASC')
  Future<List<CategoryModel>> searchItemsByName(String query);

  /// Get all distinct categories
  @Query('SELECT DISTINCT categories FROM category ORDER BY category ASC')
  Future<List<String>> getAllCategories();

  /// Check if an item with the same name exists
  @Query('SELECT COUNT(*) FROM categories WHERE name = :name')
  Future<int?> checkItemExists(String name);
}
