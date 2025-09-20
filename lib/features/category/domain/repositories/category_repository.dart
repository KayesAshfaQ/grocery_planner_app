import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';

/// Repository interface for category operations
abstract class CategoryRepository {
  /// Get all categories
  Future<Either<AppException, List<Category>>> getAllCategories();

  /// Search categories by name
  Future<Either<AppException, List<Category>>> searchCategories(String query);

  /// Get a specific category by ID
  Future<Either<AppException, Category>> getCategoryById(int id);

  /// Add a new category (typically used by administrators or for user-defined items)
  Future<Either<AppException, Category>> addCategory(Category item);

  /// Update an existing category
  Future<Either<AppException, Category>> updateCategory(Category item);

  /// Delete a category
  Future<Either<AppException, void>> deleteCategory(int id);
}
