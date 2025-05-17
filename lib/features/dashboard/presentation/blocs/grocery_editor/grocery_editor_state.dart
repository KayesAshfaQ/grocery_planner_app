part of 'grocery_editor_bloc.dart';

/// Base class for all editor states
abstract class GroceryEditorState extends Equatable {
  /// Creates a new editor state
  const GroceryEditorState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the editor bloc
class GroceryEditorInitialState extends GroceryEditorState {}

/// State when editor data is being loaded
class GroceryEditorLoadingState extends GroceryEditorState {}

/// State when editor data has been loaded successfully
class GroceryEditorLoadedState extends GroceryEditorState {
  /// The list of categories
  final List<Category> categories;

  /// The list of catalog items
  final List<CatalogItem> catalogItems;

  /// The currently selected category
  final Category? selectedCategory;

  /// The currently selected catalog item
  final CatalogItem? selectedCatalogItem;

  /// Creates a new state with loaded editor data
  const GroceryEditorLoadedState({
    required this.categories,
    required this.catalogItems,
    this.selectedCategory,
    this.selectedCatalogItem,
  });

  /// Creates a copy of this state with the given fields replaced
  GroceryEditorLoadedState copyWith({
    List<Category>? categories,
    List<CatalogItem>? catalogItems,
    Category? selectedCategory,
    CatalogItem? selectedCatalogItem,
  }) {
    return GroceryEditorLoadedState(
      categories: categories ?? this.categories,
      catalogItems: catalogItems ?? this.catalogItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCatalogItem: selectedCatalogItem,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        catalogItems,
        selectedCategory,
        selectedCatalogItem,
      ];
}

/// State when a grocery item is added
class GroceryAddedState extends GroceryEditorState {
  /// The grocery item added
  final GroceryItem item;

  /// Creates a new state with the grocery item added
  const GroceryAddedState({required this.item});

  @override
  List<Object> get props => [item];
}

/// State when grocery data is updated
class GroceryUpdatedState extends GroceryEditorState {
  /// The grocery item updated
  final GroceryItem item;

  /// Creates a new state with the grocery item updated
  const GroceryUpdatedState({required this.item});

  @override
  List<Object> get props => [item];
}

/// State when an error occurs
class GroceryEditorErrorState extends GroceryEditorState {
  /// The error message
  final String message;

  /// Creates a new error state with a message
  const GroceryEditorErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
