part of 'purchase_list_bloc.dart';

/// Base class for all grocery events
abstract class PurchaseListEvent extends Equatable {
  /// Creates a new grocery event
  const PurchaseListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get all purchase lists
class GetAllPurchaseItemsEvent extends PurchaseListEvent {}

/// Event to get purchase lists by their purchase status
class GetPurchaseListsByStatusEvent extends PurchaseListEvent {
  /// Whether the lists are purchased or not
  final bool isPurchased;

  /// Creates a new event to get purchase lists by status
  const GetPurchaseListsByStatusEvent({required this.isPurchased});

  @override
  List<Object> get props => [isPurchased];
}

/// Event to mark a purchase item as purchased
class MarkPurchaseItemAsPurchasedEvent extends PurchaseListEvent {
  /// The ID of the purchase item to mark as purchased
  final String id;

  /// Optional actual price paid for the item
  final double? actualPrice;

  /// Creates a new event to mark a purchase item as purchased
  const MarkPurchaseItemAsPurchasedEvent({
    required this.id,
    this.actualPrice,
  });

  @override
  List<Object?> get props => [id, actualPrice];
}
