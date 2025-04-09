import 'package:grocery_planner_app/core/db/dao/grocery_item_dao.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';

/// Interface for local grocery data operations
abstract class GroceryLocalDataSource {
  /// Fetches all grocery items from local storage
  Future<List<GroceryItem>> getGroceryItems();

  /// Fetches grocery items by their purchase status
  Future<List<GroceryItem>> getGroceryItemsByStatus(bool isPurchased);

  /// Fetches grocery items by their category
  Future<List<GroceryItem>> getGroceryItemsByCategory(String category);

  /// Fetches a grocery item by its ID
  Future<GroceryItem> getGroceryItemById(String id);

  /// Adds a new grocery item to local storage
  Future<void> addGroceryItem(GroceryItem item);

  /// Deletes a grocery item from local storage
  Future<void> deleteGroceryItem(String id);
}

class GroceryLocalDataSourceImpl extends GroceryLocalDataSource {
  final GroceryItemDao groceryItemDao;

  GroceryLocalDataSourceImpl({required this.groceryItemDao});

  @override
  Future<void> addGroceryItem(GroceryItem item) {
    // TODO: implement addGroceryItem
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGroceryItem(String id) {
    // TODO: implement deleteGroceryItem
    throw UnimplementedError();
  }

  @override
  Future<GroceryItem> getGroceryItemById(String id) {
    // TODO: implement getGroceryItemById
    throw UnimplementedError();
  }

  @override
  Future<List<GroceryItem>> getGroceryItems() async {
    try {
      final groceryItemModels = await groceryItemDao.getAllItems();
      if (groceryItemModels.isNotEmpty) {
        return groceryItemModels.map((item) => item.toEntity()).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch grocery items: $e');
    }
  }

  @override
  Future<List<GroceryItem>> getGroceryItemsByCategory(String category) {
    // TODO: implement getGroceryItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<GroceryItem>> getGroceryItemsByStatus(bool isPurchased) {
    // TODO: implement getGroceryItemsByStatus
    throw UnimplementedError();
  }
}
