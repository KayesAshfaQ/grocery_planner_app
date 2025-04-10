import 'package:grocery_planner_app/core/db/dao/catalog_item_dao.dart';
import 'package:grocery_planner_app/features/home/data/models/catalog_item_model.dart';
import 'package:grocery_planner_app/features/home/domain/entities/catalog_item.dart';

/// Interface for local grocery data operations
abstract class CatalogDataSource {
  /// Fetches all catalog items from db
  Future<List<CatalogItem>> getCatalogs();

  /// Fetches catalog items by their category
  Future<List<CatalogItem>> getCatalogsByCategory(String category);

  /// Searches for catalog items by their name
  Future<List<CatalogItem>> searchCatalogs(String query);

  /// Fetches a catalog item by its ID
  Future<CatalogItem> getCatalogById(String id);

  /// Adds a new catalog item to db
  Future<CatalogItem> addCatalog(CatalogItem item);

  /// Updates an existing catalog item in db
  Future<CatalogItem> updateCatalog(CatalogItem item);

  /// Deletes a catalog item from db
  Future<void> deleteCatalog(String id);

  /// Fetches all available categories from db
  Future<List<String>> getCategories();
}

class CatalogLocalDataSourceImpl extends CatalogDataSource {
  final CatalogItemDao catalogItemDao;

  CatalogLocalDataSourceImpl({required this.catalogItemDao});

  @override
  Future<List<CatalogItem>> getCatalogs() async {
    try {
      final catalogItemModels = await catalogItemDao.getAllItems();
      if (catalogItemModels.isNotEmpty) {
        return catalogItemModels.map((item) => item.toEntity()).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch catalog items: $e');
    }
  }
  
  @override
  Future<CatalogItem> addCatalog(CatalogItem item) async{
    try {
      final catalogItemModel = CatalogItemModel.fromEntity(item);
      await catalogItemDao.insertItem(catalogItemModel);
      return item;
    } catch (e) {
      throw Exception('Failed to add catalog item: $e');
    }
  }
  
  @override
  Future<void> deleteCatalog(String id) {
    // TODO: implement deleteCatalog
    throw UnimplementedError();
  }
  
  @override
  Future<CatalogItem> getCatalogById(String id) {
    // TODO: implement getCatalogById
    throw UnimplementedError();
  }
  
  @override
  Future<List<CatalogItem>> getCatalogsByCategory(String category) {
    // TODO: implement getCatalogsByCategory
    throw UnimplementedError();
  }
  
  @override
  Future<List<String>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }
  
  @override
  Future<List<CatalogItem>> searchCatalogs(String query) {
    // TODO: implement searchCatalogs
    throw UnimplementedError();
  }
  
  @override
  Future<CatalogItem> updateCatalog(CatalogItem item) {
    // TODO: implement updateCatalog
    throw UnimplementedError();
  }
}
