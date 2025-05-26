import 'package:dartz/dartz.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/purchase_repository.dart';

/// Use case for marking a grocery item as purchased
class MarkItemAsPurchasedUsecase {
  /// The grocery repository
  final PurchaseRepository repository;

  /// Creates a new MarkItemAsPurchased use case
  MarkItemAsPurchasedUsecase(this.repository);

  /// Marks a grocery item as purchased with an optional actual price
  Future<Either<AppException, PurchaseItem>> call(String id, {double? actualPrice}) async {
    return repository.markItemAsPurchased(id, actualPrice: actualPrice);
  }
}
