import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/category/domain/repositories/category_repository.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';

/// Use case for updating an existing category
class UpdateCategoryUsecase {
  final CategoryRepository repository;

  UpdateCategoryUsecase(this.repository);

  /// Updates an existing category
  Future<Either<AppException, Category>> call(Category category) async {
    return await repository.updateCategory(category);
  }
}
