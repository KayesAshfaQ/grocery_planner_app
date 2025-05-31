import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/mark_item_as_purchased_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

part 'purchase_list_event.dart';
part 'purchase_list_state.dart';

/// BLoC for managing grocery item operations
class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  final GetAllPurchaseListUsecase getAllPurchaseListUseCase;
  final MarkItemAsPurchasedUsecase markItemAsPurchasedUsecase;
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  /// Creates a new GroceryBloc
  PurchaseListBloc({
    required this.getAllPurchaseListUseCase,
    required this.markItemAsPurchasedUsecase,
    required AppEventBus eventBus,
  })  : _eventBus = eventBus,
        super(PurchaseListInitialState()) {
    on<GetAllPurchaseItemsEvent>(_onGetAllPurchaseItems);
    on<GetPurchaseListsByStatusEvent>(_onGetPurchaseItemsByStatus);
    on<MarkPurchaseItemAsPurchasedEvent>(_onMarkPurchaseItemAsPurchased);

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

  FutureOr<void> _onGetAllPurchaseItems(
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

  FutureOr<void> _onGetPurchaseItemsByStatus(
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

  FutureOr<void> _onMarkPurchaseItemAsPurchased(
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
  }
}
