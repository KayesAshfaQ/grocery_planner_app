import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/home/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/home/domain/usecases/grocery/get_grocery_item_usecase.dart';
import 'package:grocery_planner_app/features/home/domain/usecases/grocery/mark_item_as_purchased_usecase.dart';

part 'grocery_event.dart';
part 'grocery_state.dart';

/// BLoC for managing grocery item operations
class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final GetGroceryItemsUsecase getGroceryItemsUsecase;
  final MarkItemAsPurchasedUsecase markItemAsPurchasedUsecase;

  /// Creates a new GroceryBloc
  GroceryBloc({
    required this.getGroceryItemsUsecase,
    required this.markItemAsPurchasedUsecase,
  }) : super(GroceryInitialState()) {
    on<GetAllGroceryItemsEvent>(_onGetAllGroceryItems);
    on<GetGroceryItemsByStatusEvent>(_onGetGroceryItemsByStatus);
    on<GetGroceryItemsByCategoryEvent>(_onGetGroceryItemsByCategory);
    on<MarkGroceryItemAsPurchasedEvent>(_onMarkGroceryItemAsPurchased);
  }

  FutureOr<void> _onGetAllGroceryItems(
    GetAllGroceryItemsEvent event,
    Emitter<GroceryState> emit,
  ) async {
    emit(GroceryLoadingState());
    final result = await getGroceryItemsUsecase();
    result.fold(
      (failure) => emit(GroceryErrorState(message: failure.toString())),
      (groceryItems) => emit(GroceryLoadedState(items: groceryItems)),
    );
  }

  FutureOr<void> _onGetGroceryItemsByStatus(
    GetGroceryItemsByStatusEvent event,
    Emitter<GroceryState> emit,
  ) async {
    emit(GroceryLoadingState());
    final result = await getGroceryItemsUsecase.byStatus(event.isPurchased);
    result.fold(
      (failure) => emit(GroceryErrorState(message: failure.toString())),
      (groceryItems) => emit(GroceryLoadedState(items: groceryItems)),
    );
  }

  FutureOr<void> _onGetGroceryItemsByCategory(
      GetGroceryItemsByCategoryEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryLoadingState());
    final result = await getGroceryItemsUsecase.byCategory(event.category);
    result.fold(
      (failure) => emit(GroceryErrorState(message: failure.toString())),
      (groceryItems) => emit(GroceryLoadedState(items: groceryItems)),
    );
  }

  FutureOr<void> _onMarkGroceryItemAsPurchased(
    MarkGroceryItemAsPurchasedEvent event,
    Emitter<GroceryState> emit,
  ) async {
    emit(GroceryLoadingState());
    final result = await markItemAsPurchasedUsecase(
      event.id,
      actualPrice: event.actualPrice,
    );
    result.fold(
      (failure) => emit(GroceryErrorState(message: failure.toString())),
      (groceryItem) => add(GetAllGroceryItemsEvent()),
    );
  }
}
