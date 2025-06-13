import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/category/data/datasources/category_data_source.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<AppException, Category>> addCategory(Category item) async {
    try {
      final result = await dataSource.addCategory(item);
      return Right(result);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<Category>>> getAllCategories() async {
    try {
      final result = await dataSource.getCategories();
      return Right(result);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, Category>> getCategoryById(String id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<Category>>> searchCategories(String query) {
    // TODO: implement searchCategories
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, Category>> updateCategory(Category item) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
