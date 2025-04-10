part of 'grocery_bloc.dart';

/// Base class for all grocery events
abstract class GroceryEvent extends Equatable {
  /// Creates a new grocery event
  const GroceryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get all grocery items
class GetAllGroceryItemsEvent extends GroceryEvent {}

/// Event to get grocery items by their purchase status
class GetGroceryItemsByStatusEvent extends GroceryEvent {
  /// Whether the items are purchased or not
  final bool isPurchased;

  /// Creates a new event to get grocery items by status
  const GetGroceryItemsByStatusEvent({required this.isPurchased});

  @override
  List<Object> get props => [isPurchased];
}

/// Event to get grocery items by category
class GetGroceryItemsByCategoryEvent extends GroceryEvent {
  /// The category to filter by
  final String category;

  /// Creates a new event to get grocery items by category
  const GetGroceryItemsByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

/// Event to mark a grocery item as purchased
class MarkGroceryItemAsPurchasedEvent extends GroceryEvent {
  /// The ID of the grocery item to mark as purchased
  final String id;

  /// Optional actual price paid for the item
  final double? actualPrice;

  /// Creates a new event to mark a grocery item as purchased
  const MarkGroceryItemAsPurchasedEvent({
    required this.id,
    this.actualPrice,
  });

  @override
  List<Object?> get props => [id, actualPrice];
}
