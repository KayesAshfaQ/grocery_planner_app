part of 'purchase_list_editor_bloc.dart';

/// Base class for all editor states
abstract class PurchaseListEditorState extends Equatable {
  /// Creates a new editor state
  const PurchaseListEditorState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the editor bloc
class PurchaseListEditorInitialState extends PurchaseListEditorState {}

/// State when editor data is being loaded
class PurchaseListEditorLoadingState extends PurchaseListEditorState {}

/// State when editor data has been loaded successfully
class PurchaseListEditorLoadedState extends PurchaseListEditorState {
  /// The list of categories
  final List<Category> categories;

  /// The list of catalog items
  final List<CatalogItem> catalogItems;

  /// The currently selected category
  final Category? selectedCategory;

  /// The currently selected catalog item
  final CatalogItem? selectedCatalogItem;

  /// Purchase list data, if available
  final List<PurchaseItem>? purchaseItems;

  /// Creates a new state with loaded editor data
  const PurchaseListEditorLoadedState({
    required this.categories,
    required this.catalogItems,
    this.selectedCategory,
    this.selectedCatalogItem,
    this.purchaseItems,
  });

  /// Creates a copy of this state with the given fields replaced
  PurchaseListEditorLoadedState copyWith({
    List<Category>? categories,
    List<CatalogItem>? catalogItems,
    Category? selectedCategory,
    CatalogItem? selectedCatalogItem,
    List<PurchaseItem>? purchaseItems,
  }) {
    return PurchaseListEditorLoadedState(
      categories: categories ?? this.categories,
      catalogItems: catalogItems ?? this.catalogItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCatalogItem: selectedCatalogItem,
      purchaseItems: purchaseItems ?? this.purchaseItems,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        catalogItems,
        selectedCategory,
        selectedCatalogItem,
        purchaseItems,
      ];
}

/// State when a purchase item is added
class PurchaseItemAddedState extends PurchaseListEditorState {
  /// The purchase item added
  final PurchaseItem item;

  /// Creates a new state with the purchase item added
  const PurchaseItemAddedState({required this.item});

  @override
  List<Object> get props => [item];
}

/// State when a purchase list is added
class PurchaseListAddedState extends PurchaseListEditorState {
  /// The purchase list added
  final PurchaseList list;

  /// Creates a new state with the purchase list added
  const PurchaseListAddedState({required this.list});

  @override
  List<Object> get props => [list];
}

/// State when purchase list is updated
class PurchaseListUpdatedState extends PurchaseListEditorState {
  /// The purchase list updated
  final PurchaseList value;

  /// Creates a new state with the purchase list updated
  const PurchaseListUpdatedState({required this.value});

  @override
  List<Object> get props => [value];
}

/// State when an error occurs
class PurchaseListEditorErrorState extends PurchaseListEditorState {
  /// The error message
  final String message;

  /// Creates a new error state with a message
  const PurchaseListEditorErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
