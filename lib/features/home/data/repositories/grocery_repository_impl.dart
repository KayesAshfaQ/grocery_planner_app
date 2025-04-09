import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/features/home/data/datasources/local/grocery_local_data_source.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/entities/price_history.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final GroceryLocalDataSource localDataSource;

  GroceryRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<AppException, GroceryItem>> addGroceryItem(GroceryItem item) {
    // TODO: implement addGroceryItem
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, void>> deleteGroceryItem(String id) {
    // TODO: implement deleteGroceryItem
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, GroceryItem>> getGroceryItemById(String id) {
    // TODO: implement getGroceryItemById
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<GroceryItem>>> getGroceryItems() {
    // TODO: implement getGroceryItems
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByCategory(
      String category) {
    // TODO: implement getGroceryItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByStatus(
      bool isPurchased) {
    // TODO: implement getGroceryItemsByStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PriceHistory>>> getPriceHistory(
      String itemId) {
    // TODO: implement getPriceHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PriceHistory>>> getPriceHistoryByDateRange(
      DateTime startDate, DateTime endDate) {
    // TODO: implement getPriceHistoryByDateRange
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, GroceryItem>> markItemAsPurchased(String id,
      {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, GroceryItem>> updateGroceryItem(
      GroceryItem item) {
    // TODO: implement updateGroceryItem
    throw UnimplementedError();
  }

  // Implement repository methods here
}
