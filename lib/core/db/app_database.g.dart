// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  CatalogItemDao? _catalogItemDaoInstance;

  PurchaseDao? _purchaseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `description` TEXT, `image_uri` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `catalog_items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `default_unit` TEXT, `barcode` TEXT, `category_id` INTEGER, `image_uri` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `price_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `catalog_id` INTEGER NOT NULL, `price` REAL NOT NULL, `recorded_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_lists` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `is_completed` INTEGER, `budget` REAL, `currency_symbol` TEXT, `note` TEXT, `created_at` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_list_items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `list_id` INTEGER NOT NULL, `catalog_id` INTEGER, `custom_name` TEXT, `quantity` REAL NOT NULL, `unit_price` REAL, `total_price` REAL, `note` TEXT, `is_purchased` INTEGER NOT NULL, `purchased_at` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_price_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `item_id` INTEGER, `price` REAL NOT NULL, `recorded_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_schedules` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `list_id` INTEGER NOT NULL, `market_date` INTEGER NOT NULL, `notify_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_locations` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `list_id` INTEGER NOT NULL, `latitude` REAL, `longitude` REAL, `address` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `recipes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `instructions` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `recipe_ingredients` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `recipe_id` INTEGER NOT NULL, `catalog_id` INTEGER NOT NULL, `quantity` REAL, `unit` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  CatalogItemDao get catalogItemDao {
    return _catalogItemDaoInstance ??=
        _$CatalogItemDao(database, changeListener);
  }

  @override
  PurchaseDao get purchaseDao {
    return _purchaseDaoInstance ??= _$PurchaseDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryModelInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image_uri': item.imageUri
                }),
        _categoryModelUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image_uri': item.imageUri
                }),
        _categoryModelDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image_uri': item.imageUri
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryModel> _categoryModelInsertionAdapter;

  final UpdateAdapter<CategoryModel> _categoryModelUpdateAdapter;

  final DeletionAdapter<CategoryModel> _categoryModelDeletionAdapter;

  @override
  Future<List<CategoryModel>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM categories ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            imageUri: row['image_uri'] as String?));
  }

  @override
  Future<CategoryModel?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            imageUri: row['image_uri'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteItemById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM categories WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<CategoryModel>> getItemsByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE category = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            imageUri: row['image_uri'] as String?),
        arguments: [category]);
  }

  @override
  Future<List<CategoryModel>> searchItemsByName(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            imageUri: row['image_uri'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<String>> getAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT categories FROM category ORDER BY category ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<int?> checkItemExists(String name) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM categories WHERE name = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [name]);
  }

  @override
  Future<void> insertItem(CategoryModel item) async {
    await _categoryModelInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(CategoryModel item) async {
    await _categoryModelUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    await _categoryModelDeletionAdapter.delete(item);
  }
}

class _$CatalogItemDao extends CatalogItemDao {
  _$CatalogItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _catalogItemModelInsertionAdapter = InsertionAdapter(
            database,
            'catalog_items',
            (CatalogItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'default_unit': item.defaultUnit,
                  'barcode': item.barcode,
                  'category_id': item.categoryId,
                  'image_uri': item.imageUri
                }),
        _catalogItemModelUpdateAdapter = UpdateAdapter(
            database,
            'catalog_items',
            ['id'],
            (CatalogItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'default_unit': item.defaultUnit,
                  'barcode': item.barcode,
                  'category_id': item.categoryId,
                  'image_uri': item.imageUri
                }),
        _catalogItemModelDeletionAdapter = DeletionAdapter(
            database,
            'catalog_items',
            ['id'],
            (CatalogItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'default_unit': item.defaultUnit,
                  'barcode': item.barcode,
                  'category_id': item.categoryId,
                  'image_uri': item.imageUri
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CatalogItemModel> _catalogItemModelInsertionAdapter;

  final UpdateAdapter<CatalogItemModel> _catalogItemModelUpdateAdapter;

  final DeletionAdapter<CatalogItemModel> _catalogItemModelDeletionAdapter;

  @override
  Future<List<CatalogItemModel>> getAllItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM catalog_items ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            defaultUnit: row['default_unit'] as String?,
            barcode: row['barcode'] as String?,
            categoryId: row['category_id'] as int?,
            imageUri: row['image_uri'] as String?));
  }

  @override
  Future<CatalogItemModel?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM catalog_items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            defaultUnit: row['default_unit'] as String?,
            barcode: row['barcode'] as String?,
            categoryId: row['category_id'] as int?,
            imageUri: row['image_uri'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteItemById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM catalog_items WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<CatalogItemModel>> searchItemsByName(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM catalog_items WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            defaultUnit: row['default_unit'] as String?,
            barcode: row['barcode'] as String?,
            categoryId: row['category_id'] as int?,
            imageUri: row['image_uri'] as String?),
        arguments: [query]);
  }

  @override
  Future<int?> checkItemExists(String name) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM catalog_items WHERE name = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [name]);
  }

  @override
  Future<void> insertItem(CatalogItemModel item) async {
    await _catalogItemModelInsertionAdapter.insert(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(CatalogItemModel item) async {
    await _catalogItemModelUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(CatalogItemModel item) async {
    await _catalogItemModelDeletionAdapter.delete(item);
  }
}

class _$PurchaseDao extends PurchaseDao {
  _$PurchaseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _purchaseListModelInsertionAdapter = InsertionAdapter(
            database,
            'purchase_lists',
            (PurchaseListModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_completed': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'budget': item.budget,
                  'currency_symbol': item.currencySymbol,
                  'note': item.note,
                  'created_at': item.createdAt
                }),
        _purchaseItemModelInsertionAdapter = InsertionAdapter(
            database,
            'purchase_list_items',
            (PurchaseItemModel item) => <String, Object?>{
                  'id': item.id,
                  'list_id': item.listId,
                  'catalog_id': item.catalogId,
                  'custom_name': item.customName,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                  'total_price': item.totalPrice,
                  'note': item.note,
                  'is_purchased': item.isPurchased ? 1 : 0,
                  'purchased_at': item.purchasedAt
                }),
        _purchaseListModelUpdateAdapter = UpdateAdapter(
            database,
            'purchase_lists',
            ['id'],
            (PurchaseListModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_completed': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'budget': item.budget,
                  'currency_symbol': item.currencySymbol,
                  'note': item.note,
                  'created_at': item.createdAt
                }),
        _purchaseItemModelUpdateAdapter = UpdateAdapter(
            database,
            'purchase_list_items',
            ['id'],
            (PurchaseItemModel item) => <String, Object?>{
                  'id': item.id,
                  'list_id': item.listId,
                  'catalog_id': item.catalogId,
                  'custom_name': item.customName,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                  'total_price': item.totalPrice,
                  'note': item.note,
                  'is_purchased': item.isPurchased ? 1 : 0,
                  'purchased_at': item.purchasedAt
                }),
        _purchaseListModelDeletionAdapter = DeletionAdapter(
            database,
            'purchase_lists',
            ['id'],
            (PurchaseListModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_completed': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'budget': item.budget,
                  'currency_symbol': item.currencySymbol,
                  'note': item.note,
                  'created_at': item.createdAt
                }),
        _purchaseItemModelDeletionAdapter = DeletionAdapter(
            database,
            'purchase_list_items',
            ['id'],
            (PurchaseItemModel item) => <String, Object?>{
                  'id': item.id,
                  'list_id': item.listId,
                  'catalog_id': item.catalogId,
                  'custom_name': item.customName,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                  'total_price': item.totalPrice,
                  'note': item.note,
                  'is_purchased': item.isPurchased ? 1 : 0,
                  'purchased_at': item.purchasedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PurchaseListModel> _purchaseListModelInsertionAdapter;

  final InsertionAdapter<PurchaseItemModel> _purchaseItemModelInsertionAdapter;

  final UpdateAdapter<PurchaseListModel> _purchaseListModelUpdateAdapter;

  final UpdateAdapter<PurchaseItemModel> _purchaseItemModelUpdateAdapter;

  final DeletionAdapter<PurchaseListModel> _purchaseListModelDeletionAdapter;

  final DeletionAdapter<PurchaseItemModel> _purchaseItemModelDeletionAdapter;

  @override
  Future<List<PurchaseListModel>> getAllLists() async {
    return _queryAdapter.queryList(
        'SELECT * FROM purchase_lists ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => PurchaseListModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isCompleted: row['is_completed'] == null
                ? null
                : (row['is_completed'] as int) != 0,
            budget: row['budget'] as double?,
            currencySymbol: row['currency_symbol'] as String?,
            note: row['note'] as String?,
            createdAt: row['created_at'] as String?));
  }

  @override
  Future<PurchaseListModel?> getListById(String id) async {
    return _queryAdapter.query('SELECT * FROM purchase_lists WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PurchaseListModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isCompleted: row['is_completed'] == null
                ? null
                : (row['is_completed'] as int) != 0,
            budget: row['budget'] as double?,
            currencySymbol: row['currency_symbol'] as String?,
            note: row['note'] as String?,
            createdAt: row['created_at'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteListById(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM purchase_lists WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<PurchaseItemModel>> getAllItemsByListId(String listId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM purchase_items WHERE listId = ?1 ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => PurchaseItemModel(id: row['id'] as int?, listId: row['list_id'] as int, catalogId: row['catalog_id'] as int?, customName: row['custom_name'] as String?, quantity: row['quantity'] as double, unitPrice: row['unit_price'] as double?, totalPrice: row['total_price'] as double?, note: row['note'] as String?, isPurchased: (row['is_purchased'] as int) != 0, purchasedAt: row['purchased_at'] as String?),
        arguments: [listId]);
  }

  @override
  Future<PurchaseItemModel?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM purchase_items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PurchaseItemModel(
            id: row['id'] as int?,
            listId: row['list_id'] as int,
            catalogId: row['catalog_id'] as int?,
            customName: row['custom_name'] as String?,
            quantity: row['quantity'] as double,
            unitPrice: row['unit_price'] as double?,
            totalPrice: row['total_price'] as double?,
            note: row['note'] as String?,
            isPurchased: (row['is_purchased'] as int) != 0,
            purchasedAt: row['purchased_at'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteItemById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM purchase_items WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertList(PurchaseListModel item) async {
    await _purchaseListModelInsertionAdapter.insert(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertItem(PurchaseItemModel item) async {
    await _purchaseItemModelInsertionAdapter.insert(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateList(PurchaseListModel item) async {
    await _purchaseListModelUpdateAdapter.update(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(PurchaseItemModel item) async {
    await _purchaseItemModelUpdateAdapter.update(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteList(PurchaseListModel item) async {
    await _purchaseListModelDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteItem(PurchaseItemModel item) async {
    await _purchaseItemModelDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
