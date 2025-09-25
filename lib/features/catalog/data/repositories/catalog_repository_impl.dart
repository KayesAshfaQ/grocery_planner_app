import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogDataSource dataSource;

  CatalogRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<AppException, List<CatalogItem>>> getCatalogItems() async {
    try {
      final catalogItems = await dataSource.getCatalogs();
      return Right(catalogItems);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, List<CatalogItem>>> getCatalogItemsByCategory(
      String category) {
    // TODO: implement getCatalogItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<CatalogItem>>> searchCatalogItems(
      String query) {
    // TODO: implement searchCatalogItems
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, CatalogItem>> getCatalogItemById(int id) {
    // TODO: implement getCatalogItemById
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, CatalogItem>> addCatalogItem(
      CatalogItem item) async {
    try {
      final result = await dataSource.addCatalog(item);
      return Right(result);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, CatalogItem>> updateCatalogItem(
      CatalogItem item) async {
    try {
      final result = await dataSource.updateCatalog(item);
      return Right(result);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> deleteCatalogItem(int id) async {
    try {
      await dataSource.deleteCatalog(id);
      return const Right(null);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}
