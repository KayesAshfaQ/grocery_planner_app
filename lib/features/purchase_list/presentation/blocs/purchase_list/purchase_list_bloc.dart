import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/add_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/remove_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/get_purchase_list_usecase.dart';

part 'purchase_list_event.dart';
part 'purchase_list_state.dart';

/// BLoC for managing grocery item operations
class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  final GetPurchaseListUsecase getAllPurchaseListUseCase;
  final AddPurchaseListUsecase addPurchaseListUsecase;
  final RemovePurchaseListUsecase removePurchaseListUsecase;
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  /// Creates a new GroceryBloc
  PurchaseListBloc({
    required this.getAllPurchaseListUseCase,
    required this.addPurchaseListUsecase,
    required this.removePurchaseListUsecase,
    required AppEventBus eventBus,
  })  : _eventBus = eventBus,
        super(PurchaseListInitialState()) {
    on<GetAllPurchaseItemsEvent>(_onGetAllPurchaseList);
    on<GetPurchaseListsByStatusEvent>(_onGetPurchaseListsByStatus);
    on<AddPurchaseListEvent>(_onAddPurchaseList);
    // on<MarkPurchaseItemAsPurchasedEvent>(_onMarkPurchaseItemAsPurchased);

    // Subscribe to events from the event bus
    _eventSubscription = _eventBus.stream.listen((event) {
      if (event is AddPurchaseListEvent) {
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
    emit(PurchaseListLoadingState());
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
        // _eventBus.fire(event);

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

  /* FutureOr<void> _onMarkPurchaseItemAsPurchased(
    MarkPurchaseItemAsPurchasedEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    emit(PurchaseListLoadingState());
    final result = await markItemAsPurchasedUsecase(
      event.id,
      actualPrice: event.actualPrice,
    );
    result.fold(
      (failure) => emit(PurchaseListErrorState(message: failure.toString())),
      (purchaseItem) => add(GetAllPurchaseItemsEvent()),
    );
  } */
}
