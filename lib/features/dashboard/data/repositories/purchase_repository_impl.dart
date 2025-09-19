import 'package:dartz/dartz.dart';

import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/purchase_list/data/datasources/purchase_data_source.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDataSource dataSource;

  PurchaseRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<AppException, PurchaseList>> addPurchaseList(
      PurchaseList item) async {
    try {
      await dataSource.addPurchaseList(item);
      return Right(item);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, PurchaseItem>> addPurchaseItem(
      PurchaseItem item) async {
    try {
      final insertedItem = await dataSource.addPurchaseItem(item);
      return Right(insertedItem);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, List<PurchaseItem>>> addMultiplePurchaseItems(
      List<PurchaseItem> items) async {
    try {
      final insertedItems = await dataSource.addMultiplePurchaseItems(items);
      return Right(insertedItems);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, PurchaseItem>> updatePurchaseItem(
      PurchaseItem item) async {
    try {
      await dataSource.updatePurchaseItem(item);
      return Right(item);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> removePurchaseItem(int id) async {
    try {
      await dataSource.removePurchaseItem(id);
      return Right(null);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> deletePurchaseList(int id) {
    // TODO: implement deletePurchaseList
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PurchaseItem>>> getPurchaseItemsByCategory(
      String category) {
    // TODO: implement getPurchaseItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseList>> getPurchaseListById(int id) async {
    try {
      final purchaseList = await dataSource.getPurchaseListById(id);
      return Right(purchaseList);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, List<PurchaseList>>> getPurchaseLists() async {
    try {
      final groceryItems = await dataSource.getPurchaseLists();
      return Right(groceryItems);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, List<PurchaseList>>> getPurchaseListsByStatus(
      bool isPurchased) {
    // TODO: implement getPurchaseListsByStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseItem>> markItemAsPurchased(String id,
      {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseList>> updatePurchaseList(
      PurchaseList item) async {
    try {
      await dataSource.updatePurchaseList(item);
      return Right(item);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }
}
