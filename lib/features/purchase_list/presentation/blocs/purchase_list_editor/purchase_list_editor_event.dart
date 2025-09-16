part of 'purchase_list_editor_bloc.dart';

/// Base class for all editor events
abstract class PurchaseListEditorEvent extends Equatable {
  /// Creates a new editor event
  const PurchaseListEditorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial data for the editor
class LoadInitialDataEvent extends PurchaseListEditorEvent {
  /// The ID of the purchase list to load
  final int id;

  /// Creates a new event to load a purchase list by ID
  const LoadInitialDataEvent({required this.id});

  @override
  List<Object> get props => [id];
}

/// Event to select a catalog item
class SelectCatalogItemEvent extends PurchaseListEditorEvent {
  /// The selected catalog item
  final CatalogItem? catalogItem;

  /// Creates a new event to select a catalog item
  const SelectCatalogItemEvent({required this.catalogItem});

  @override
  List<Object?> get props => [catalogItem];
}

/// Event to select a category
class SelectCategoryEvent extends PurchaseListEditorEvent {
  /// The selected category
  final Category category;

  /// Creates a new event to select a category
  const SelectCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

/// Event to find a category by ID
class FindCategoryByIdEvent extends PurchaseListEditorEvent {
  /// The ID of the category to find
  final int categoryId;

  /// Creates a new event to find a category by ID
  const FindCategoryByIdEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

/// Event to insert a new category
class InsertCategoryEvent extends PurchaseListEditorEvent {
  /// The name of the category to insert
  final String name;

  /// Creates a new event to insert a category
  const InsertCategoryEvent({required this.name});

  @override
  List<Object> get props => [name];
}

/// Event to add a new PurchaseList
class AddPurchaseListEvent extends PurchaseListEditorEvent implements AppEvent {
  /// The purchase list to be added
  final PurchaseList list;

  /// Creates a new event to add a purchase list
  const AddPurchaseListEvent({required this.list});

  @override
  List<Object?> get props => [list];
}

/// Event to update an existing purchase item
class UpdatePurchaseListEvent extends PurchaseListEditorEvent {
  /// The purchase item to be updated
  final PurchaseItem item;

  /// Creates a new event to update a purchase item
  const UpdatePurchaseListEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to add an item to the current purchase list
class AddItemToPurchaseListEvent extends PurchaseListEditorEvent {
  /// The purchase item to be added
  final PurchaseItem item;

  /// Creates a new event to add a purchase item
  const AddItemToPurchaseListEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to add multiple items to the current purchase list
class AddMultipleItemsToPurchaseListEvent extends PurchaseListEditorEvent
    implements AppEvent {
  /// The list of purchase items to be added
  final List<PurchaseItem> items;

  /// Creates a new event to add multiple purchase items
  const AddMultipleItemsToPurchaseListEvent({required this.items});

  @override
  List<Object?> get props => [items];
}

/// Event to remove an item from the current purchase list
class RemoveItemFromPurchaseListEvent extends PurchaseListEditorEvent
    implements AppEvent {
  /// The ID of the purchase item to remove
  final int id;

  /// Creates a new event to remove a purchase item
  const RemoveItemFromPurchaseListEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
