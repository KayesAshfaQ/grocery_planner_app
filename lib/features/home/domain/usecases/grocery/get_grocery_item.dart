
import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';

/// Use case for retrieving grocery items
class GetGroceryItems {
  /// The grocery repository
  final GroceryRepository repository;

  /// Creates a new GetGroceryItems use case
  GetGroceryItems(this.repository);

  /// Gets all grocery items
  Future<Either<Exception, List<GroceryItem>>> call() async {
    return repository.getGroceryItems();
  }

  /// Gets grocery items by their purchase status
  Future<Either<Exception, List<GroceryItem>>> byStatus(
      bool isPurchased) async {
    return repository.getGroceryItemsByStatus(isPurchased);
  }

  /// Gets grocery items by their category
  Future<Either<Exception, List<GroceryItem>>> byCategory(
      String category) async {
    return repository.getGroceryItemsByCategory(category);
  }
}
