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
  Future<Either<AppException, PurchaseList>> addPurchaseList(PurchaseList item) async {
    try {
      await dataSource.addPurchaseList(item);
      return Right(item);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<Either<AppException, PurchaseItem>> addPurchaseItem(PurchaseItem item) {
    // TODO: implement addPurchaseItem
    throw UnimplementedError();
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
  Future<Either<AppException, void>> deletePurchaseList(String id) {
    // TODO: implement deletePurchaseList
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<PurchaseItem>>> getPurchaseItemsByCategory(String category) {
    // TODO: implement getPurchaseItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseList>> getPurchaseListById(String id) {
    // TODO: implement getPurchaseListById
    throw UnimplementedError();
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
  Future<Either<AppException, List<PurchaseList>>> getPurchaseListsByStatus(bool isPurchased) {
    // TODO: implement getPurchaseListsByStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseItem>> markItemAsPurchased(String id, {double? actualPrice}) {
    // TODO: implement markItemAsPurchased
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, PurchaseList>> updatePurchaseList(PurchaseList item) {
    // TODO: implement updatePurchaseList
    throw UnimplementedError();
  }
}
