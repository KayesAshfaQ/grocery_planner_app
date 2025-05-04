part of 'grocery_editor_bloc.dart';

/// Base class for all editor events
abstract class GroceryEditorEvent extends Equatable {
  /// Creates a new editor event
  const GroceryEditorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load categories and catalog items
class LoadCategoriesAndCatalogItemsEvent extends GroceryEditorEvent {}

/// Event to select a catalog item
class SelectCatalogItemEvent extends GroceryEditorEvent {
  /// The selected catalog item
  final CatalogItem? catalogItem;

  /// Creates a new event to select a catalog item
  const SelectCatalogItemEvent({required this.catalogItem});

  @override
  List<Object?> get props => [catalogItem];
}

/// Event to select a category
class SelectCategoryEvent extends GroceryEditorEvent {
  /// The selected category
  final String category;

  /// Creates a new event to select a category
  const SelectCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}


/// Event to add a new grocery item
class AddGroceryItemEvent extends GroceryEditorEvent {
  /// The grocery item to be added
  final GroceryItem item;

  /// Creates a new event to add a grocery item
  const AddGroceryItemEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to update an existing grocery item
class UpdateGroceryItemEvent extends GroceryEditorEvent {
  /// The grocery item to be updated
  final GroceryItem item;

  /// Creates a new event to update a grocery item
  const UpdateGroceryItemEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Event to delete a grocery item
class DeleteGroceryItemEvent extends GroceryEditorEvent {
  /// The ID of the grocery item to delete
  final String id;

  /// Creates a new event to delete a grocery item
  const DeleteGroceryItemEvent({required this.id});

  @override
  List<Object?> get props => [id];
}