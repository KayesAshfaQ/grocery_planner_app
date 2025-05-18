import 'package:grocery_planner_app/core/db/dao/category_dao.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/category_model.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/category.dart';

/// Interface for local grocery data operations
abstract class CategoryDataSource {
  /// Fetches all categories from db
  Future<List<Category>> getCategories();

  /// Searches for categories by their name
  Future<List<Category>> searchCategories(String query);

  /// Fetches a category by its ID
  Future<Category> getCategoryById(String id);

  /// Adds a new category to db
  Future<Category> addCategory(Category item);

  /// Updates an existing category in db
  Future<Category> updateCategory(Category item);

  /// Deletes a category from db
  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl extends CategoryDataSource {
  final CategoryDao categoryItemDao;

  CategoryLocalDataSourceImpl({required this.categoryItemDao});

  @override
  Future<Category> addCategory(Category item) async {
    try {
      final catalogItemModel = CategoryModel.fromEntity(item);
      await categoryItemDao.insertItem(catalogItemModel);
      return item;
    } catch (e) {
      throw Exception('Failed to add category item: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await categoryItemDao.deleteItemById(id);
    } catch (e) {
      throw Exception('Failed to delete category item: $e');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categoryItemModels = await categoryItemDao.getAllItems();
      if (categoryItemModels.isNotEmpty) {
        return categoryItemModels.map((item) => item.toEntity()).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch category items: $e');
    }
  }

  @override
  Future<Category> getCategoryById(String id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> searchCategories(String query) {
    // TODO: implement searchCategories
    throw UnimplementedError();
  }

  @override
  Future<Category> updateCategory(Category item) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
