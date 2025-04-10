import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/catalog_repository.dart';

/// Use case for retrieving all available categories
class GetCategoriesUsecase {
  /// The catalog repository
  final CatalogRepository repository;

  /// Creates a new GetCategories use case
  GetCategoriesUsecase(this.repository);

  /// Gets all available categories
  Future<Either<AppException, List<String>>> call() async {
    return repository.getCategories();
  }
}
