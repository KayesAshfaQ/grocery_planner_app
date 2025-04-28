import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/features/home/data/datasources/grocery_data_source.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/entities/price_history.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final GroceryDataSource dataSource;

  GroceryRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<AppException, GroceryItem>> addGroceryItem(GroceryItem item) async {
    try {
      await dataSource.addGroceryItem(item);
      return Right(item);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
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
  Future<Either<AppException, List<GroceryItem>>> getGroceryItems() async {
    try {
      final groceryItems = await dataSource.getGroceryItems();
      return Right(groceryItems);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByCategory(String category) {
    // TODO: implement getGroceryItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<GroceryItem>>> getGroceryItemsByStatus(bool isPurchased) {
    // TODO: implement getGroceryItemsByStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PriceHistory>>> getPriceHistory(String itemId) {
    // TODO: implement getPriceHistory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PriceHistory>>> getPriceHistoryByDateRange(DateTime startDate, DateTime endDate) {
    // TODO: implement getPriceHistoryByDateRange
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, GroceryItem>> markItemAsPurchased(String id, {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, GroceryItem>> updateGroceryItem(GroceryItem item) {
    // TODO: implement updateGroceryItem
    throw UnimplementedError();
  }

  // Implement repository methods here
}
