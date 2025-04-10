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

  GroceryItemDao? _groceryItemDaoInstance;

  CatalogItemDao? _catalogItemDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `CategorySpendingModel` (`id` TEXT NOT NULL, `category` TEXT NOT NULL, `value` REAL NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `grocery_items` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `quantity` REAL NOT NULL, `unit` TEXT NOT NULL, `unitPrice` REAL NOT NULL, `category` TEXT NOT NULL, `note` TEXT, `isPurchased` INTEGER NOT NULL, `createdAtMillis` INTEGER NOT NULL, `purchasedAtMillis` INTEGER, `purchasedPrice` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `catalog_items` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `availableUnitsCSV` TEXT NOT NULL, `defaultUnit` TEXT NOT NULL, `category` TEXT NOT NULL, `averagePrice` REAL, `imageUrl` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GroceryItemDao get groceryItemDao {
    return _groceryItemDaoInstance ??=
        _$GroceryItemDao(database, changeListener);
  }

  @override
  CatalogItemDao get catalogItemDao {
    return _catalogItemDaoInstance ??=
        _$CatalogItemDao(database, changeListener);
  }
}

class _$GroceryItemDao extends GroceryItemDao {
  _$GroceryItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _groceryItemModelInsertionAdapter = InsertionAdapter(
            database,
            'grocery_items',
            (GroceryItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity,
                  'unit': item.unit,
                  'unitPrice': item.unitPrice,
                  'category': item.category,
                  'note': item.note,
                  'isPurchased': item.isPurchased ? 1 : 0,
                  'createdAtMillis': item.createdAtMillis,
                  'purchasedAtMillis': item.purchasedAtMillis,
                  'purchasedPrice': item.purchasedPrice
                }),
        _groceryItemModelUpdateAdapter = UpdateAdapter(
            database,
            'grocery_items',
            ['id'],
            (GroceryItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity,
                  'unit': item.unit,
                  'unitPrice': item.unitPrice,
                  'category': item.category,
                  'note': item.note,
                  'isPurchased': item.isPurchased ? 1 : 0,
                  'createdAtMillis': item.createdAtMillis,
                  'purchasedAtMillis': item.purchasedAtMillis,
                  'purchasedPrice': item.purchasedPrice
                }),
        _groceryItemModelDeletionAdapter = DeletionAdapter(
            database,
            'grocery_items',
            ['id'],
            (GroceryItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity,
                  'unit': item.unit,
                  'unitPrice': item.unitPrice,
                  'category': item.category,
                  'note': item.note,
                  'isPurchased': item.isPurchased ? 1 : 0,
                  'createdAtMillis': item.createdAtMillis,
                  'purchasedAtMillis': item.purchasedAtMillis,
                  'purchasedPrice': item.purchasedPrice
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GroceryItemModel> _groceryItemModelInsertionAdapter;

  final UpdateAdapter<GroceryItemModel> _groceryItemModelUpdateAdapter;

  final DeletionAdapter<GroceryItemModel> _groceryItemModelDeletionAdapter;

  @override
  Future<List<GroceryItemModel>> getAllItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM grocery_items ORDER BY createdAtMillis DESC',
        mapper: (Map<String, Object?> row) => GroceryItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            quantity: row['quantity'] as double,
            unit: row['unit'] as String,
            unitPrice: row['unitPrice'] as double,
            category: row['category'] as String,
            note: row['note'] as String?,
            isPurchased: (row['isPurchased'] as int) != 0,
            createdAtMillis: row['createdAtMillis'] as int,
            purchasedAtMillis: row['purchasedAtMillis'] as int?,
            purchasedPrice: row['purchasedPrice'] as double?));
  }

  @override
  Future<List<GroceryItemModel>> getItemsByStatus(bool isPurchased) async {
    return _queryAdapter.queryList(
        'SELECT * FROM grocery_items WHERE isPurchased = ?1 ORDER BY createdAtMillis DESC',
        mapper: (Map<String, Object?> row) => GroceryItemModel(id: row['id'] as String, name: row['name'] as String, quantity: row['quantity'] as double, unit: row['unit'] as String, unitPrice: row['unitPrice'] as double, category: row['category'] as String, note: row['note'] as String?, isPurchased: (row['isPurchased'] as int) != 0, createdAtMillis: row['createdAtMillis'] as int, purchasedAtMillis: row['purchasedAtMillis'] as int?, purchasedPrice: row['purchasedPrice'] as double?),
        arguments: [isPurchased ? 1 : 0]);
  }

  @override
  Future<GroceryItemModel?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM grocery_items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => GroceryItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            quantity: row['quantity'] as double,
            unit: row['unit'] as String,
            unitPrice: row['unitPrice'] as double,
            category: row['category'] as String,
            note: row['note'] as String?,
            isPurchased: (row['isPurchased'] as int) != 0,
            createdAtMillis: row['createdAtMillis'] as int,
            purchasedAtMillis: row['purchasedAtMillis'] as int?,
            purchasedPrice: row['purchasedPrice'] as double?),
        arguments: [id]);
  }

  @override
  Future<void> deleteItemById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM grocery_items WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<GroceryItemModel>> getItemsByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM grocery_items WHERE category = ?1 ORDER BY createdAtMillis DESC',
        mapper: (Map<String, Object?> row) => GroceryItemModel(id: row['id'] as String, name: row['name'] as String, quantity: row['quantity'] as double, unit: row['unit'] as String, unitPrice: row['unitPrice'] as double, category: row['category'] as String, note: row['note'] as String?, isPurchased: (row['isPurchased'] as int) != 0, createdAtMillis: row['createdAtMillis'] as int, purchasedAtMillis: row['purchasedAtMillis'] as int?, purchasedPrice: row['purchasedPrice'] as double?),
        arguments: [category]);
  }

  @override
  Future<List<GroceryItemModel>> getItemsByDateRange(
    int startMillis,
    int endMillis,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM grocery_items WHERE createdAtMillis BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => GroceryItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            quantity: row['quantity'] as double,
            unit: row['unit'] as String,
            unitPrice: row['unitPrice'] as double,
            category: row['category'] as String,
            note: row['note'] as String?,
            isPurchased: (row['isPurchased'] as int) != 0,
            createdAtMillis: row['createdAtMillis'] as int,
            purchasedAtMillis: row['purchasedAtMillis'] as int?,
            purchasedPrice: row['purchasedPrice'] as double?),
        arguments: [startMillis, endMillis]);
  }

  @override
  Future<List<CategorySpendingModel>> getTotalSpendingByCategory(
    int startMillis,
    int endMillis,
  ) async {
    return _queryAdapter.queryList(
        'SELECT category, SUM(CASE WHEN purchasedPrice IS NOT NULL THEN purchasedPrice ELSE unitPrice * quantity END) as value     FROM grocery_items     WHERE isPurchased = 1 AND purchasedAtMillis BETWEEN ?1 AND ?2     GROUP BY category',
        mapper: (Map<String, Object?> row) => CategorySpendingModel(id: row['id'] as String, category: row['category'] as String, value: row['value'] as double),
        arguments: [startMillis, endMillis]);
  }

  @override
  Future<void> insertItem(GroceryItemModel item) async {
    await _groceryItemModelInsertionAdapter.insert(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(GroceryItemModel item) async {
    await _groceryItemModelUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(GroceryItemModel item) async {
    await _groceryItemModelDeletionAdapter.delete(item);
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
                  'availableUnitsCSV': item.availableUnitsCSV,
                  'defaultUnit': item.defaultUnit,
                  'category': item.category,
                  'averagePrice': item.averagePrice,
                  'imageUrl': item.imageUrl
                }),
        _catalogItemModelUpdateAdapter = UpdateAdapter(
            database,
            'catalog_items',
            ['id'],
            (CatalogItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'availableUnitsCSV': item.availableUnitsCSV,
                  'defaultUnit': item.defaultUnit,
                  'category': item.category,
                  'averagePrice': item.averagePrice,
                  'imageUrl': item.imageUrl
                }),
        _catalogItemModelDeletionAdapter = DeletionAdapter(
            database,
            'catalog_items',
            ['id'],
            (CatalogItemModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'availableUnitsCSV': item.availableUnitsCSV,
                  'defaultUnit': item.defaultUnit,
                  'category': item.category,
                  'averagePrice': item.averagePrice,
                  'imageUrl': item.imageUrl
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
            id: row['id'] as String,
            name: row['name'] as String,
            availableUnitsCSV: row['availableUnitsCSV'] as String,
            defaultUnit: row['defaultUnit'] as String,
            category: row['category'] as String,
            averagePrice: row['averagePrice'] as double?,
            imageUrl: row['imageUrl'] as String?));
  }

  @override
  Future<CatalogItemModel?> getItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM catalog_items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            availableUnitsCSV: row['availableUnitsCSV'] as String,
            defaultUnit: row['defaultUnit'] as String,
            category: row['category'] as String,
            averagePrice: row['averagePrice'] as double?,
            imageUrl: row['imageUrl'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteItemById(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM catalog_items WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<CatalogItemModel>> getItemsByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM catalog_items WHERE category = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            availableUnitsCSV: row['availableUnitsCSV'] as String,
            defaultUnit: row['defaultUnit'] as String,
            category: row['category'] as String,
            averagePrice: row['averagePrice'] as double?,
            imageUrl: row['imageUrl'] as String?),
        arguments: [category]);
  }

  @override
  Future<List<CatalogItemModel>> searchItemsByName(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM catalog_items WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CatalogItemModel(
            id: row['id'] as String,
            name: row['name'] as String,
            availableUnitsCSV: row['availableUnitsCSV'] as String,
            defaultUnit: row['defaultUnit'] as String,
            category: row['category'] as String,
            averagePrice: row['averagePrice'] as double?,
            imageUrl: row['imageUrl'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<String>> getAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT category FROM catalog_items ORDER BY category ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
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
