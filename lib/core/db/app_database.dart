import 'dart:async';

import 'package:floor/floor.dart';
import 'package:grocery_planner_app/core/db/converter/date_time_converter.dart';
import 'package:grocery_planner_app/core/db/dao/catalog_item_dao.dart';
import 'package:grocery_planner_app/core/db/dao/category_dao.dart';
import 'package:grocery_planner_app/core/db/dao/purchase_dao.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
// Import the core database models
import 'package:grocery_planner_app/features/shared/data/models/index.dart';

// Required for Floor to generate database
part 'app_database.g.dart';

@TypeConverters([
  // Add your type converters here
  DateTimeConverter,
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
