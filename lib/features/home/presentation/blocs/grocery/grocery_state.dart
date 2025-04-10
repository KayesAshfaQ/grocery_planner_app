part of 'grocery_bloc.dart';

/// Base class for all grocery states
abstract class GroceryState extends Equatable {
  /// Creates a new grocery state
  const GroceryState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the grocery bloc
class GroceryInitialState extends GroceryState {}

/// State when grocery data is being loaded
class GroceryLoadingState extends GroceryState {}

/// State when grocery data has been loaded successfully
class GroceryLoadedState extends GroceryState {
  /// The list of grocery items
  final List<GroceryItem> items;

  /// Creates a new state with loaded grocery items
  const GroceryLoadedState({required this.items});

  @override
  List<Object> get props => [items];
}

/// State when an error occurs
class GroceryErrorState extends GroceryState {
  /// The error message
  final String message;

  /// Creates a new error state with a message
  const GroceryErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
