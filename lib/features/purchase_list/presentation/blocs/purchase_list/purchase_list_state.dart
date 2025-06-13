part of 'purchase_list_bloc.dart';

/// Base class for all purchase list states
abstract class PurchaseListState extends Equatable {
  /// Creates a new purchase list state
  const PurchaseListState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the purchase list bloc
class PurchaseListInitialState extends PurchaseListState {}

/// State when purchase list data is being loaded
class PurchaseListLoadingState extends PurchaseListState {}

/// State when purchase list data has been loaded successfully
class PurchaseListLoadedState extends PurchaseListState {
  /// The list of purchaseList items
  final List<PurchaseList> items;

  /// Creates a new state with loaded purchaseList items
  const PurchaseListLoadedState({required this.items});

  @override
  List<Object> get props => [items];
}

/// State when an error occurs
class PurchaseListErrorState extends PurchaseListState {
  /// The error message
  final String message;

  /// Creates a new error state with a message
  const PurchaseListErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
