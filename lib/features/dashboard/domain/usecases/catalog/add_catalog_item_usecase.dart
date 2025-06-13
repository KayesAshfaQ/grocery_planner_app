import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/catalog_repository.dart';

/// Use case for adding a new catalog item
class AddCatalogItemUsecase {
  /// The catalog repository
  final CatalogRepository repository;

  /// Creates a new AddCatalogItem use case
  AddCatalogItemUsecase(this.repository);

  /// Adds a new catalog item
  Future<Either<AppException, CatalogItem>> call(CatalogItem item) async {
    return repository.addCatalogItem(item);
  }
}
