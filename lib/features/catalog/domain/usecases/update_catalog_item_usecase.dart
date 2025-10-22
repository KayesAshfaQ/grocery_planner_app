import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/catalog/domain/repositories/catalog_repository.dart';

/// Use case for updating an existing catalog item
class UpdateCatalogItemUsecase {
  /// The catalog repository
  final CatalogRepository repository;

  /// Creates a new UpdateCatalogItem use case
  UpdateCatalogItemUsecase(this.repository);

  /// Updates an existing catalog item
  Future<Either<AppException, CatalogItem>> call(CatalogItem item) async {
    return repository.updateCatalogItem(item);
  }
}
