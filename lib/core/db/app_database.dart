import 'dart:async';

import 'package:floor/floor.dart';
import 'package:grocery_planner_app/core/db/converter/date_time_converter.dart';
import 'package:grocery_planner_app/core/db/dao/catalog_item_dao.dart';
import 'package:grocery_planner_app/core/db/dao/category_dao.dart';
import 'package:grocery_planner_app/core/db/dao/models/category_spending_model.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/catalog_item_model.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/category_model.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:grocery_planner_app/core/db/dao/grocery_item_dao.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/grocery_item_model.dart';
// Import the core database models
import 'package:grocery_planner_app/features/dashboard/data/model/index.dart';

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
    // Existing models
    CategorySpendingModel,
    GroceryItemModel,
    CatalogItemModel,
    CategoryModel,

    // Core database models
    CategoryModel,
    CatalogItemModel,
    PriceHistory,
    PurchaseListModel,
    PurchaseItemModel,
    PurchasePriceHistory,
    PurchaseSchedule,
    PurchaseLocation,
    Recipe,
    RecipeIngredient,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  /// Access to grocery item data
  GroceryItemDao get groceryItemDao;

  /// Access to catalog item data
  CatalogItemDao get catalogItemDao;

  /// Access to category item data
  CategoryDao get categoryItemDao;

  // You'll need to add DAO getters for your other models too
  // For example:
  // CategoryDao get categoryDao;
  // PurchaseListDao get purchaseListDao;
  // etc.
}
