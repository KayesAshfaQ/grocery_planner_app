
import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/grocery_repository.dart';

/// Use case for retrieving grocery items
class GetGroceryItemsUsecase {
  /// The grocery repository
  final GroceryRepository repository;

  /// Creates a new GetGroceryItems use case
  GetGroceryItemsUsecase(this.repository);

  /// Gets all grocery items
  Future<Either<AppException, List<GroceryItem>>> call() async {
    return repository.getGroceryItems();
  }

  /// Gets grocery items by their purchase status
  Future<Either<AppException, List<GroceryItem>>> byStatus(
      bool isPurchased) async {
    return repository.getGroceryItemsByStatus(isPurchased);
  }

  /// Gets grocery items by their category
  Future<Either<AppException, List<GroceryItem>>> byCategory(
      String category) async {
    return repository.getGroceryItemsByCategory(category);
  }
}
