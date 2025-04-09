import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/entities/price_history.dart';

/// Repository interface for grocery item operations
abstract class GroceryRepository {
  /// Get all grocery items
  Future<Either<AppException, List<GroceryItem>>> getGroceryItems();

  /// Get grocery items by their completion status
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByStatus(
      bool isPurchased);

  /// Get a specific grocery item by ID
  Future<Either<AppException, GroceryItem>> getGroceryItemById(String id);

  /// Add a new grocery item
  Future<Either<AppException, GroceryItem>> addGroceryItem(GroceryItem item);

  /// Update an existing grocery item
  Future<Either<AppException, GroceryItem>> updateGroceryItem(GroceryItem item);

  /// Delete a grocery item
  Future<Either<AppException, void>> deleteGroceryItem(String id);

  /// Mark a grocery item as purchased with optional actual price
  Future<Either<AppException, GroceryItem>> markItemAsPurchased(String id,
      {double? actualPrice});

  /// Get price history for a specific grocery item
  Future<Either<AppException, List<PriceHistory>>> getPriceHistory(String itemId);

  /// Get price history for all grocery items within a date range
  Future<Either<AppException, List<PriceHistory>>> getPriceHistoryByDateRange(
      DateTime startDate, DateTime endDate);

  /// Get grocery items by their category
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByCategory(
      String category);
}
