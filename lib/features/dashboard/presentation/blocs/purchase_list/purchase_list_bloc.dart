import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/mark_item_as_purchased_usecase.dart';

part 'purchase_list_event.dart';
part 'purchase_list_state.dart';

/// BLoC for managing grocery item operations
class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  final GetPurchaseListUsecase getPurchaseListUsecase;
  final MarkItemAsPurchasedUsecase markItemAsPurchasedUsecase;

  /// Creates a new GroceryBloc
  PurchaseListBloc({
    required this.getPurchaseListUsecase,
    required this.markItemAsPurchasedUsecase,
  }) : super(PurchaseListInitialState()) {
    on<GetAllPurchaseItemsEvent>(_onGetAllPurchaseItems);
    on<GetPurchaseListsByStatusEvent>(_onGetPurchaseItemsByStatus);
    on<MarkPurchaseItemAsPurchasedEvent>(_onMarkPurchaseItemAsPurchased);
  }

  FutureOr<void> _onGetAllPurchaseItems(
    GetAllPurchaseItemsEvent event,
    Emitter<PurchaseListState> emit,
  ) async {
    emit(PurchaseListLoadingState());
    final result = await getPurchaseListUsecase();
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
    final result = await getPurchaseListUsecase.byStatus(event.isPurchased);
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
