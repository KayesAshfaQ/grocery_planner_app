import 'dart:async';

import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
// Import the core database models

import '../../features/shared/data/models/catalog_item_model.dart';
import '../../features/shared/data/models/category_model.dart';
import '../../features/shared/data/models/price_history.dart';
import '../../features/shared/data/models/purchase_item_model.dart';
import '../../features/shared/data/models/purchase_list_model.dart';
import '../../features/shared/data/models/purchase_location.dart';
import '../../features/shared/data/models/purchase_price_history_model.dart';
import '../../features/shared/data/models/purchase_schedule.dart';
import '../../features/shared/data/models/recipe.dart';
import '../../features/shared/data/models/recipe_ingredient.dart';
import 'converter/date_time_converter.dart';
import 'converter/nullable_date_time_converter.dart';
import 'dao/catalog_item_dao.dart';
import 'dao/category_dao.dart';
import 'dao/purchase_dao.dart';

// Required for Floor to generate database
part 'app_database.g.dart';

@TypeConverters([
  // Add your type converters here
  DateTimeConverter,
  NullableDateTimeConverter,
])

/// The main database for the grocery planner app
///
/// This database contains tables for grocery items, shopping schedules,
/// catalog items, and price history records.
@Database(
  version: 1,
  entities: [
    // Core database models
    CategoryModel,
    CatalogItemModel,
    PriceHistory,
    PurchaseListModel,
    PurchaseItemModel,
    PurchasePriceHistoryModel,
    PurchaseSchedule,
    PurchaseLocation,
    Recipe,
    RecipeIngredient,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  /// Access to category data
  CategoryDao get categoryDao;

  /// Access to catalog item data
  CatalogItemDao get catalogItemDao;

  /// Access to purchase data
  PurchaseDao get purchaseDao;

  // You'll need to add DAO getters for your other models too
  // For example:
  // CategoryDao get categoryDao;
  // PurchaseListDao get purchaseListDao;
  // etc.
}
