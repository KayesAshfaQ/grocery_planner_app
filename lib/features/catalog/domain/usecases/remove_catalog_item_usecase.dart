import 'package:dartz/dartz.dart';
import '../repositories/catalog_repository.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';

class RemoveCatalogItemUsecase {
  final CatalogRepository repository;

  RemoveCatalogItemUsecase(this.repository);

  Future<Either<AppException, void>> call(int catalogId) async {
    return repository.deleteCatalogItem(catalogId);
  }
}
