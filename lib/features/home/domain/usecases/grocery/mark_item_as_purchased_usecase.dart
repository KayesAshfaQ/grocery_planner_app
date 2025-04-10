import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';

/// Use case for marking a grocery item as purchased
class MarkItemAsPurchasedUsecase {
  /// The grocery repository
  final GroceryRepository repository;

  /// Creates a new MarkItemAsPurchased use case
  MarkItemAsPurchasedUsecase(this.repository);

  /// Marks a grocery item as purchased with an optional actual price
  Future<Either<AppException, GroceryItem>> call(String id,
      {double? actualPrice}) async {
    return repository.markItemAsPurchased(id, actualPrice: actualPrice);
  }
}
