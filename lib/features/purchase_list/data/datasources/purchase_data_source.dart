import 'package:grocery_planner_app/core/db/dao/purchase_dao.dart';
import 'package:grocery_planner_app/core/extensions/datetime_extension.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_item_model.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_list_model.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';

/// Interface for local purchase data operations
abstract class PurchaseDataSource {
  /// Fetches all purchase items from local storage
  Future<List<PurchaseList>> getPurchaseLists();

  /// Fetches a purchase item by its ID
  Future<PurchaseList> getPurchaseListById(int id);

  /// Fetches purchase items by their purchase status
  Future<List<PurchaseList>> getPurchaseListsByStatus(bool isPurchased);

  /// Adds a new purchase list to local storage
  Future<void> addPurchaseList(PurchaseList item);

  /// Update an existing purchase list in local storage
  Future<PurchaseList> updatePurchaseList(PurchaseList item);

  /// Deletes a purchase list by its ID
  Future<void> deletePurchaseList(int id);

  /// Adds a new purchase item to local storage
  /// Adds a new purchase item to the database and returns the item with generated ID
  Future<PurchaseItem> addPurchaseItem(PurchaseItem item);

  /// Updates an existing purchase item in local storage
  Future<void> updatePurchaseItem(PurchaseItem item);

  /// Marks a purchase item as purchased, optionally with an actual price
  Future<PurchaseItem> markItemAsPurchased(String id, {double? actualPrice});

  /// Removes a purchase item from local storage
  Future<void> removePurchaseItem(int id);

  /// Fetches purchase items by their category
  Future<List<PurchaseItem>> getPurchaseItemsByCategory(String category);

  /// Fetches purchase lists created within a date range
  Future<List<PurchaseList>> getPurchaseListsByDateRange(
      DateTime start, DateTime end);

  /// Fetches purchase lists created today
  Future<List<PurchaseList>> getPurchaseListsCreatedToday();

  /// Fetches purchase lists created this week
  Future<List<PurchaseList>> getPurchaseListsCreatedThisWeek();

  /// Fetches purchase lists created this month
  Future<List<PurchaseList>> getPurchaseListsCreatedThisMonth();
}

class PurchaseLocalDataSourceImpl extends PurchaseDataSource {
  final PurchaseDao purchaseDao;

  PurchaseLocalDataSourceImpl({required this.purchaseDao});

  @override
  Future<List<PurchaseList>> getPurchaseLists() async {
    try {
      final purchaseListModels = await purchaseDao.getAllLists();
      if (purchaseListModels.isNotEmpty) {
        // For each purchase list, fetch its associated purchase items
        List<PurchaseList> purchaseLists = [];
        for (final listModel in purchaseListModels) {
          final purchaseItemModels =
              await purchaseDao.getAllItemsByListId(listModel.id!);
          final purchaseItems =
              purchaseItemModels.map((item) => item.toEntity()).toList();
          purchaseLists.add(listModel.toEntity(purchaseItems: purchaseItems));
        }
        return purchaseLists;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch purchase lists: $e');
    }
  }

  @override
  Future<PurchaseList> getPurchaseListById(int id) async {
    try {
      final purchaseListModel = await purchaseDao.getListById(id);
      if (purchaseListModel == null) {
        throw Exception('Purchase list not found with ID: $id');
      }

      // Fetch all purchase items for this list
      final purchaseItemModels = await purchaseDao.getAllItemsByListId(id);
      final purchaseItems =
          purchaseItemModels.map((item) => item.toEntity()).toList();

      // Convert to entity with the loaded purchase items
      return purchaseListModel.toEntity(purchaseItems: purchaseItems);
    } catch (e) {
      throw Exception('Failed to fetch purchase list by ID: $e');
    }
  }

  @override
  Future<List<PurchaseList>> getPurchaseListsByStatus(bool isPurchased) {
    // TODO: implement getPurchaseListsByStatus
    throw UnimplementedError();
  }

  @override
  Future<void> addPurchaseList(PurchaseList item) async {
    try {
      await purchaseDao.insertList(PurchaseListModel.fromEntity(item));
    } catch (e) {
      throw Exception('Failed to add purchase list: $e');
    }
  }

  @override
  Future<PurchaseList> updatePurchaseList(PurchaseList item) {
    // TODO: implement updatePurchaseList
    throw UnimplementedError();
  }

  @override
  Future<void> deletePurchaseList(int id) {
    // TODO: implement deletePurchaseList
    throw UnimplementedError();
  }

  @override
  Future<PurchaseItem> addPurchaseItem(PurchaseItem item) async {
    try {
      final insertedId =
          await purchaseDao.insertItem(PurchaseItemModel.fromEntity(item));
      // Return the item with the generated ID
      return item.copyWith(id: insertedId);
    } catch (e) {
      throw Exception('Failed to add purchase item: $e');
    }
  }

  @override
  Future<void> updatePurchaseItem(PurchaseItem item) async {
    try {
      await purchaseDao.updateItem(PurchaseItemModel.fromEntity(item));
    } catch (e) {
      throw Exception('Failed to update purchase item: $e');
    }
  }

  @override
  Future<PurchaseItem> markItemAsPurchased(String id, {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
  }

  @override
  Future<void> removePurchaseItem(int id) async {
    try {
      await purchaseDao.deleteItemById(id);
    } catch (e) {
      throw Exception('Failed to remove purchase item: $e');
    }
  }

  @override
  Future<List<PurchaseItem>> getPurchaseItemsByCategory(String category) {
    // TODO: implement getPurchaseItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<PurchaseList>> getPurchaseListsByDateRange(
      DateTime start, DateTime end) async {
    try {
      final range = DateTimeUtils.createRange(start, end);
      final purchaseListModels =
          await purchaseDao.getListsByDateRange(range.start, range.end);
      return purchaseListModels.map((item) => item.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch purchase lists by date range: $e');
    }
  }

  @override
  Future<List<PurchaseList>> getPurchaseListsCreatedToday() async {
    try {
      final purchaseListModels = await purchaseDao
          .getListsCreatedToday(DateTimeUtils.todayStartMillis);
      return purchaseListModels.map((item) => item.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch today\'s purchase lists: $e');
    }
  }

  @override
  Future<List<PurchaseList>> getPurchaseListsCreatedThisWeek() async {
    try {
      final purchaseListModels = await purchaseDao
          .getListsCreatedThisWeek(DateTimeUtils.weekStartMillis);
      return purchaseListModels.map((item) => item.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch this week\'s purchase lists: $e');
    }
  }

  @override
  Future<List<PurchaseList>> getPurchaseListsCreatedThisMonth() async {
    try {
      final purchaseListModels = await purchaseDao
          .getListsCreatedThisMonth(DateTimeUtils.monthStartMillis);
      return purchaseListModels.map((item) => item.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch this month\'s purchase lists: $e');
    }
  }
}
