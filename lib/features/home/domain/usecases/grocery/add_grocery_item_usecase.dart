
import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';

/// Use case for adding a new grocery item
class AddGroceryItemUsecase {
  /// The grocery repository
  final GroceryRepository repository;

  /// Creates a new AddGroceryItem use case
  AddGroceryItemUsecase(this.repository);

  /// Adds a new grocery item
  Future<Either<AppException, GroceryItem>> call(GroceryItem item) async {
    return repository.addGroceryItem(item);
  }
}