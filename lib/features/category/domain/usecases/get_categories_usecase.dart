import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/category/domain/repositories/category_repository.dart';

/// Use case for retrieving all available categories
class GetCategoriesUsecase {
  /// The category repository
  final CategoryRepository repository;

  /// Creates a new GetCategories use case
  GetCategoriesUsecase(this.repository);

  /// Gets all available categories
  Future<Either<AppException, List<Category>>> call() async {
    return repository.getAllCategories();
  }
}
