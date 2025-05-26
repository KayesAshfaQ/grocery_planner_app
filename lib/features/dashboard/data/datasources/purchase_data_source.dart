import 'package:grocery_planner_app/core/db/dao/purchase_dao.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/purchase_item_model.dart';
import 'package:grocery_planner_app/features/dashboard/data/models/purchase_list_model.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';

/// Interface for local grocery data operations
abstract class PurchaseDataSource {
  /// Adds a new grocery item to local storage
  Future<void> addPurchaseList(PurchaseList item);

  /// Adds a new grocery item to local storage
  Future<void> addPurchaseItem(PurchaseItem item);

  /// Deletes a grocery item from local storage
  Future<void> deletePurchaseList(String id);

  /// Fetches grocery items by their category
  Future<List<PurchaseItem>> getPurchaseItemsByCategory(String category);

  /// Fetches a grocery item by its ID
  Future<PurchaseList> getPurchaseListById(String id);

  /// Fetches all grocery items from local storage
  Future<List<PurchaseList>> getPurchaseLists();

  /// Fetches grocery items by their purchase status
  Future<List<PurchaseList>> getPurchaseListsByStatus(bool isPurchased);

  Future<PurchaseItem> markItemAsPurchased(String id, {double? actualPrice});

  Future<PurchaseList> updatePurchaseList(PurchaseList item);
}

class PurchaseLocalDataSourceImpl extends PurchaseDataSource {
  final PurchaseDao purchaseDao;

  PurchaseLocalDataSourceImpl({required this.purchaseDao});

  @override
  Future<void> addPurchaseList(PurchaseList item) async {
    try {
      await purchaseDao.insertList(PurchaseListModel.fromEntity(item));
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  @override
  Future<void> addPurchaseItem(PurchaseItem item) async {
    try {
      await purchaseDao.insertItem(PurchaseItemModel.fromEntity(item));
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  @override
  Future<List<PurchaseItem>> getPurchaseItemsByCategory(String category) {
    // TODO: implement getPurchaseItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<PurchaseList> getPurchaseListById(String id) {
    // TODO: implement getPurchaseListById
    throw UnimplementedError();
  }

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
  Future<List<PurchaseList>> getPurchaseListsByStatus(bool isPurchased) {
    // TODO: implement getPurchaseListsByStatus
    throw UnimplementedError();
  }

  @override
  Future<PurchaseItem> markItemAsPurchased(String id, {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
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
}
