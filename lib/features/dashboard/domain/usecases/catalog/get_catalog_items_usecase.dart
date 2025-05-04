import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/catalog_repository.dart';

/// Use case for retrieving all available categories
class GetCatalogItemsUsecase {
  /// The catalog repository
  final CatalogRepository repository;

  /// Creates a new GetCategories use case
  GetCatalogItemsUsecase(this.repository);

  /// Gets all available categories
  Future<Either<AppException, List<CatalogItem>>> call() async {
    return repository.getCatalogItems();
  }
}
