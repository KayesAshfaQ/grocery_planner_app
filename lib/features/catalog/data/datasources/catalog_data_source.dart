import 'package:grocery_planner_app/core/db/dao/catalog_item_dao.dart';
import 'package:grocery_planner_app/core/db/dao/category_dao.dart';
import 'package:grocery_planner_app/features/shared/data/models/catalog_item_model.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';

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
}

class CatalogLocalDataSourceImpl extends CatalogDataSource {
  final CatalogItemDao catalogItemDao;
  final CategoryDao categoryDao;

  CatalogLocalDataSourceImpl({required this.catalogItemDao, required this.categoryDao});

  @override
  Future<List<CatalogItem>> getCatalogs() async {
    try {
      // Fetch all catalog items from the database
      final catalogItemModels = await catalogItemDao.getAllItems();
      if (catalogItemModels.isEmpty) return [];

      // Extract unique category IDs
      final categoryIds = catalogItemModels
          .where((item) => item.categoryId != null)
          .map((item) => item.categoryId!)
          .toSet()
          .map((id) => id)
          .toList();

      // Fetch all needed categories in one batch
      Map<int, Category> categoryMap = {};
      if (categoryIds.isNotEmpty) {
        final categories = await Future.wait(categoryIds.map((id) => categoryDao.getItemById(id)));

        // Create lookup map of ID -> Category
        for (var category in categories.where((c) => c != null)) {
          categoryMap[category!.id!] = category.toEntity();
        }
      }

      // Associate categories with catalog items
      return catalogItemModels
          .map((model) => CatalogItem(
                id: model.id,
                name: model.name,
                defaultUnit: model.defaultUnit,
                barcode: model.barcode,
                imageUri: model.imageUri,
                category: model.categoryId != null ? categoryMap[model.categoryId] : null,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch catalog items: $e');
    }
  }

  @override
  Future<CatalogItem> addCatalog(CatalogItem item) async {
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
