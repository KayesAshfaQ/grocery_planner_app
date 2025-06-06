import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/category.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/category_repository.dart';

/// Use case for adding a new category
class AddCategoryUsecase {
  /// The category repository
  final CategoryRepository repository;

  /// Creates a new AddCategory use case
  AddCategoryUsecase(this.repository);

  /// Adds a new category
  Future<Either<AppException, Category>> call(Category item) async {
    return repository.addCategory(item);
  }
}
