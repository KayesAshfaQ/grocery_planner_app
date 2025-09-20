import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/category/domain/repositories/category_repository.dart';

/// Use case for deleting an existing category
class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  /// Deletes an existing category by ID
  Future<Either<AppException, void>> call(int categoryId) async {
    return await repository.deleteCategory(categoryId);
  }
}
