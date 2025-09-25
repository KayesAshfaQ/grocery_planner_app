import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/add_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/remove_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/update_purchase_list_usecase.dart';

part 'purchase_list_event.dart';
part 'purchase_list_state.dart';

/// BLoC for managing grocery item operations
class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  final GetPurchaseListUsecase getAllPurchaseListUseCase;
  final AddPurchaseListUsecase addPurchaseListUsecase;
  final RemovePurchaseListUsecase removePurchaseListUsecase;
  final UpdatePurchaseListUsecase updatePurchaseListUsecase;
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  /// Creates a new GroceryBloc
  PurchaseListBloc({
    required this.getAllPurchaseListUseCase,
    required this.addPurchaseListUsecase,
    required this.removePurchaseListUsecase,
    required this.updatePurchaseListUsecase,
    required AppEventBus eventBus,
  })  : _eventBus = eventBus,
        super(PurchaseListInitialState()) {
    on<GetAllPurchaseItemsEvent>(_onGetAllPurchaseList);
    on<GetPurchaseListsByStatusEvent>(_onGetPurchaseListsByStatus);
    on<AddPurchaseListEvent>(_onAddPurchaseList);
    on<UpdatePurchaseListEvent>(_onUpdatePurchaseList);
    on<RemovePurchaseListEvent>(_onRemovePurchaseList);

    // Subscribe to events from the event bus
    _eventSubscription = _eventBus.stream.listen((event) {
      // Refresh the list when any purchase-related operation happens
      // This is a simple, robust approach that works with any editor changes
      if (event is AddItemToPurchaseListEvent ||
          event is RemoveItemFromPurchaseListEvent ||
          event is UpdatePurchaseItemEvent ||
          event is AddMultipleItemsToPurchaseListEvent) {
        add(GetAllPurchaseItemsEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onGetAllPurchaseList(
    GetAllPurchaseItemsEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    // Only emit loading state if we don't have data yet
    if (state is! PurchaseListLoadedState) {
      emit(PurchaseListLoadingState());
    }

    final result = await getAllPurchaseListUseCase();
    result.fold(
      (failure) => emit(PurchaseListErrorState(message: failure.toString())),
      (purchaseItems) => emit(PurchaseListLoadedState(items: purchaseItems)),
    );
  }

  FutureOr<void> _onGetPurchaseListsByStatus(
    GetPurchaseListsByStatusEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    emit(PurchaseListLoadingState());
    final result = await getAllPurchaseListUseCase.byStatus(event.isPurchased);
    result.fold(
      (failure) => emit(PurchaseListErrorState(message: failure.toString())),
      (purchaseItems) => emit(PurchaseListLoadedState(items: purchaseItems)),
    );
  }

  FutureOr<void> _onAddPurchaseList(
    AddPurchaseListEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    emit(PurchaseListLoadingState());
    final result = await addPurchaseListUsecase(event.item);
    result.fold(
      (failure) => emit(PurchaseListErrorState(message: failure.toString())),
      (purchaseList) {
        // Notify other blocs about the new list through the event bus
        // _eventBus.fire(AddPurchaseListEvent(item: purchaseList));

        // Only update if we have a loaded state
        if (state is PurchaseListLoadedState) {
          final currentState = state as PurchaseListLoadedState;
          // final updatedLists = List<PurchaseList>.from(currentState.items)..add(purchaseList);
          final updatedLists = [...currentState.items, purchaseList];
          emit(PurchaseListLoadedState(items: updatedLists));
        } else {
          // If state is not loaded, trigger a full reload
          add(GetAllPurchaseItemsEvent());
        }
      },
    );
  }

  FutureOr<void> _onUpdatePurchaseList(
    UpdatePurchaseListEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    // Perform the actual update operation
    final result = await updatePurchaseListUsecase(event.item);
    result.fold(
      (failure) {
        // Revert UI state on error
        if (state is PurchaseListLoadedState) {
          emit(PurchaseListErrorState(message: failure.toString()));
          add(GetAllPurchaseItemsEvent()); // Refresh to get correct state
        }
      },
      (updatedList) {
        // Use efficient state updates - avoid loading state for better UX
        if (state is PurchaseListLoadedState) {
          final currentState = state as PurchaseListLoadedState;
          final updatedLists = currentState.items
              .map((list) => list.id == event.item.id ? event.item : list)
              .toList();
          emit(PurchaseListLoadedState(items: updatedLists));
        }
      },
    );
  }

  FutureOr<void> _onRemovePurchaseList(
    RemovePurchaseListEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    // Perform the actual delete operation
    final result = await removePurchaseListUsecase(event.id);
    result.fold(
      (failure) {
        // Revert UI state on error
        if (state is PurchaseListLoadedState) {
          emit(PurchaseListErrorState(message: failure.toString()));
          add(GetAllPurchaseItemsEvent()); // Refresh to get correct state
        }
      },
      (_) {
        // Update existing loaded state by removing the item
        if (state is PurchaseListLoadedState) {
          final currentState = state as PurchaseListLoadedState;
          final updatedLists =
              currentState.items.where((list) => list.id != event.id).toList();
          emit(PurchaseListLoadedState(items: updatedLists));
        }
      },
    );
  }
}
