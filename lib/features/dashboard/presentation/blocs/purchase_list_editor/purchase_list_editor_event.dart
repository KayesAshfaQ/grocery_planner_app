part of 'purchase_list_editor_bloc.dart';

/// Base class for all editor events
abstract class PurchaseListEditorEvent extends Equatable {
  /// Creates a new editor event
  const PurchaseListEditorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load categories and catalog items
class LoadCategoriesAndCatalogItemsEvent extends PurchaseListEditorEvent {}

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

/// Event to add a new grocery item
class AddPurchaseItemEvent extends PurchaseListEditorEvent {
  /// The purchase item to be added
  final PurchaseItem item;

  /// Creates a new event to add a purchase item
  const AddPurchaseItemEvent({required this.item});

  @override
  List<Object?> get props => [item];
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

/// Event to delete a grocery item
class DeleteGroceryItemEvent extends PurchaseListEditorEvent {
  /// The ID of the grocery item to delete
  final String id;

  /// Creates a new event to delete a grocery item
  const DeleteGroceryItemEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
