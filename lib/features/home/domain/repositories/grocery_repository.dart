import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/entities/price_history.dart';

/// Repository interface for grocery item operations
abstract class GroceryRepository {
  /// Get all grocery items
  Future<Either<Exception, List<GroceryItem>>> getGroceryItems();

  /// Get grocery items by their completion status
  Future<Either<Exception, List<GroceryItem>>> getGroceryItemsByStatus(
      bool isPurchased);

  /// Get a specific grocery item by ID
  Future<Either<Exception, GroceryItem>> getGroceryItemById(String id);

  /// Add a new grocery item
  Future<Either<Exception, GroceryItem>> addGroceryItem(GroceryItem item);

  /// Update an existing grocery item
  Future<Either<Exception, GroceryItem>> updateGroceryItem(GroceryItem item);

  /// Delete a grocery item
  Future<Either<Exception, void>> deleteGroceryItem(String id);

  /// Mark a grocery item as purchased with optional actual price
  Future<Either<Exception, GroceryItem>> markItemAsPurchased(String id,
      {double? actualPrice});

  /// Get price history for a specific grocery item
  Future<Either<Exception, List<PriceHistory>>> getPriceHistory(String itemId);

  /// Get price history for all grocery items within a date range
  Future<Either<Exception, List<PriceHistory>>> getPriceHistoryByDateRange(
      DateTime startDate, DateTime endDate);

  /// Get grocery items by their category
  Future<Either<Exception, List<GroceryItem>>> getGroceryItemsByCategory(
      String category);
}
