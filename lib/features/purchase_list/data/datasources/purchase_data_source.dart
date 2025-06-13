import 'package:grocery_planner_app/core/db/dao/purchase_dao.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_item_model.dart';
import 'package:grocery_planner_app/features/shared/data/models/purchase_list_model.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';

/// Interface for local purchase data operations
abstract class PurchaseDataSource {
  /// Fetches all purchase items from local storage
  Future<List<PurchaseList>> getPurchaseLists();

  /// Fetches a purchase item by its ID
  Future<PurchaseList> getPurchaseListById(String id);

  /// Fetches purchase items by their purchase status
  Future<List<PurchaseList>> getPurchaseListsByStatus(bool isPurchased);

  /// Adds a new purchase list to local storage
  Future<void> addPurchaseList(PurchaseList item);

  /// Update an existing purchase list in local storage
  Future<PurchaseList> updatePurchaseList(PurchaseList item);

  /// Deletes a purchase list from local storage
  Future<void> deletePurchaseList(String id);

  /// Adds a new purchase item to local storage
  Future<void> addPurchaseItem(PurchaseItem item);

  /// Marks a purchase item as purchased, optionally with an actual price
  Future<PurchaseItem> markItemAsPurchased(String id, {double? actualPrice});

  /// Removes a purchase item from local storage
  Future<void> removePurchaseItem(int id);

  /// Fetches purchase items by their category
  Future<List<PurchaseItem>> getPurchaseItemsByCategory(String category);
}

class PurchaseLocalDataSourceImpl extends PurchaseDataSource {
  final PurchaseDao purchaseDao;

  PurchaseLocalDataSourceImpl({required this.purchaseDao});

  @override
  Future<List<PurchaseList>> getPurchaseLists() async {
    try {
      final purchaseListModels = await purchaseDao.getAllLists();
      if (purchaseListModels.isNotEmpty) {
        return purchaseListModels.map((item) => item.toEntity()).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch purchase lists: $e');
    }
  }

  @override
  Future<PurchaseList> getPurchaseListById(String id) {
    // TODO: implement getPurchaseListById
    throw UnimplementedError();
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
  Future<void> deletePurchaseList(String id) {
    // TODO: implement deletePurchaseList
    throw UnimplementedError();
  }

  @override
  Future<void> addPurchaseItem(PurchaseItem item) async {
    try {
      await purchaseDao.insertItem(PurchaseItemModel.fromEntity(item));
    } catch (e) {
      throw Exception('Failed to add purchase item: $e');
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
}
