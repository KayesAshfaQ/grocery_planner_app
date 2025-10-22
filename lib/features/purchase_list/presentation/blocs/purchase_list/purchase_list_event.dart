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

/// Event to update an existing purchase item
class UpdatePurchaseListEvent extends PurchaseListEvent {
  /// The purchase item to be updated
  final PurchaseList item;

  /// Creates a new event to update a purchase item
  const UpdatePurchaseListEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to add a new purchase list
class AddPurchaseListEvent extends PurchaseListEvent implements AppEvent {
  /// The purchase list to be added
  final PurchaseList item;

  /// Creates a new event to add a purchase list
  const AddPurchaseListEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to remove a purchase list
class RemovePurchaseListEvent extends PurchaseListEvent {
  /// The ID of the purchase list to remove
  final int id;

  /// Creates a new event to remove a purchase list
  const RemovePurchaseListEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
