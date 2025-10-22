import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/add_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/update_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/update_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/remove_purchase_item_usecase.dart';

part 'purchase_list_editor_event.dart';
part 'purchase_list_editor_state.dart';

/// BLoC for managing grocery item editor operations
class PurchaseListEditorBloc
    extends Bloc<PurchaseListEditorEvent, PurchaseListEditorState> {
  final GetPurchaseListUsecase getPurchaseListUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetCatalogItemsUsecase getCatalogItemsUsecase;
  final AddPurchaseItemUsecase addPurchaseItemUsecase;
  final UpdatePurchaseItemUsecase updatePurchaseItemUsecase;
  final UpdatePurchaseListUsecase updatePurchaseListUsecase;
  final RemovePurchaseItemUsecase removePurchaseItemUsecase;
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  /// Creates a new EditorBloc
  PurchaseListEditorBloc({
    required this.getPurchaseListUsecase,
    required this.getCategoriesUsecase,
    required this.getCatalogItemsUsecase,
    required this.addPurchaseItemUsecase,
    required this.updatePurchaseItemUsecase,
    required this.updatePurchaseListUsecase,
    required this.removePurchaseItemUsecase,
    required AppEventBus eventBus,
  })  : _eventBus = eventBus,
        super(PurchaseListEditorInitialState()) {
    on<LoadInitialDataEvent>(_onLoadInitialData);
    on<SelectCatalogItemEvent>(_onSelectCatalogItem);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<FindCategoryByIdEvent>(_onFindCategoryById);
    on<InsertCategoryEvent>(_onInsertCategory);
    on<AddItemToPurchaseListEvent>(_onAddItemToPurchaseList);
    on<AddMultipleItemsToPurchaseListEvent>(_onAddMultipleItemsToPurchaseList);
    on<UpdatePurchaseItemEvent>(_onUpdatePurchaseItem);
    on<RemoveItemFromPurchaseListEvent>(_onRemoveItemFromPurchaseList);

    // Subscribe to events from the event bus
    _eventSubscription = _eventBus.stream.listen((event) {
      if (event is AddMultipleItemsToPurchaseListEvent) {
        log('PurchaseListEditorBloc: Detected AddMultipleItemsToPurchaseListEvent from EventBus');
        // if (event.items.isNotEmpty) {
        //   final listId = event.items.first.listId;
        //   add(LoadInitialDataEvent(id: listId));
        // }
      }
    });
  }

  /// Helper method to update purchase list completion status based on its items
  Future<void> _updatePurchaseListCompletionStatus(
      PurchaseList purchaseList) async {
    final purchaseItems = purchaseList.purchaseItems;
    final isAllItemsPurchased = purchaseItems.isEmpty
        ? false
        : purchaseItems.every((item) => item.isPurchased);

    // Only update if the completion status has changed
    if (purchaseList.isCompleted != isAllItemsPurchased) {
      final updatedList =
          purchaseList.copyWith(isCompleted: isAllItemsPurchased);
      await updatePurchaseListUsecase(updatedList);
    }
  }

  FutureOr<void> _onLoadInitialData(
    LoadInitialDataEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    emit(PurchaseListEditorLoadingState());

    try {
      final purchaseListResult = await getPurchaseListUsecase.byId(event.id);
      final categoriesResult = await getCategoriesUsecase();
      final catalogItemsResult = await getCatalogItemsUsecase();

      late PurchaseList purchaseList;
      List<Category> categories = [];
      List<CatalogItem> catalogItems = [];

      purchaseListResult.fold(
        (failure) => emit(PurchaseListEditorErrorState(
            message: 'Error loading purchase list: ${failure.message}')),
        (list) {
          purchaseList = list;
        },
      );

      catalogItemsResult.fold(
        (failure) => emit(PurchaseListEditorErrorState(
            message: 'Error loading catalog items: ${failure.message}')),
        (items) {
          catalogItems = items;
        },
      );

      categoriesResult.fold(
        (failure) => emit(PurchaseListEditorErrorState(
            message: 'Error loading categories: ${failure.message}')),
        (loadedCategories) {
          categories = loadedCategories;
        },
      );

      // Only emit the loaded state if we didn't emit an error state
      if (state is PurchaseListEditorLoadingState) {
        emit(PurchaseListEditorLoadedState(
          purchaseList: purchaseList,
          categories: categories,
          catalogItems: catalogItems,
        ));
      }
    } catch (e) {
      emit(PurchaseListEditorErrorState(message: 'Unexpected error: $e'));
    }
  }

  FutureOr<void> _onSelectCatalogItem(
    SelectCatalogItemEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      emit(currentState.copyWith(selectedCatalogItem: event.catalogItem));
    }
  }

  FutureOr<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  FutureOr<void> _onFindCategoryById(
    FindCategoryByIdEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      final category = currentState.categories
          .firstWhere((category) => category.id == event.categoryId);
      emit(currentState.copyWith(selectedCategory: category));
    }
  }

  FutureOr<void> _onInsertCategory(
    InsertCategoryEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      final newCategory = Category(name: event.name);
      final updatedCategories = List<Category>.from(currentState.categories)
        ..add(newCategory);
      emit(currentState.copyWith(categories: updatedCategories));
    }
  }

  FutureOr<void> _onAddItemToPurchaseList(
    AddItemToPurchaseListEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    if (state is! PurchaseListEditorLoadedState) {
      emit(PurchaseListEditorErrorState(
          message: 'Cannot add item: editor not loaded'));
      return;
    }

    final currentState = state as PurchaseListEditorLoadedState;
    // emit(PurchaseListEditorLoadingState());

    final result = await addPurchaseItemUsecase(event.item);
    result.fold(
      (failure) =>
          emit(PurchaseListEditorErrorState(message: failure.toString())),
      (purchaseItem) {
        // ✅ EFFICIENT: Update existing loaded state with new item
        final currentItems = currentState.purchaseList?.purchaseItems ?? [];
        final updatedItems = [...currentItems, purchaseItem];
        final updatedPurchaseList =
            currentState.purchaseList?.copyWith(purchaseItems: updatedItems);

        emit(currentState.copyWith(purchaseList: updatedPurchaseList));

        // 🔥 Fire existing BLoC event to notify main purchase list page to refresh
        _eventBus.fire(AddItemToPurchaseListEvent(item: purchaseItem));
      },
    );
  }

  FutureOr<void> _onAddMultipleItemsToPurchaseList(
    AddMultipleItemsToPurchaseListEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    if (state is! PurchaseListEditorLoadedState) {
      emit(PurchaseListEditorErrorState(
          message: 'Cannot add items: editor not loaded'));
      return;
    }

    final currentState = state as PurchaseListEditorLoadedState;
    // emit(PurchaseListEditorLoadingState());

    // ✅ OPTIMIZED: Use bulk insert API instead of for loop
    final result = await addPurchaseItemUsecase.addMultiple(event.items);
    result.fold(
      (failure) =>
          emit(PurchaseListEditorErrorState(message: failure.toString())),
      (addedItems) {
        // ✅ EFFICIENT: Update existing loaded state with new items
        final currentItems = currentState.purchaseList?.purchaseItems ?? [];
        final updatedItems = [...currentItems, ...addedItems];
        final updatedPurchaseList =
            currentState.purchaseList?.copyWith(purchaseItems: updatedItems);

        emit(currentState.copyWith(purchaseList: updatedPurchaseList));

        // 🔥 Fire shared event to notify main purchase list page to refresh
        _eventBus.fire(AddMultipleItemsToPurchaseListEvent(items: addedItems));
      },
    );
  }

  FutureOr<void> _onRemoveItemFromPurchaseList(
      RemoveItemFromPurchaseListEvent event,
      Emitter<PurchaseListEditorState> emit) async {
    if (state is! PurchaseListEditorLoadedState) {
      emit(PurchaseListEditorErrorState(
          message: 'Cannot remove item: editor not loaded'));
      return;
    }

    final currentState = state as PurchaseListEditorLoadedState;
    // emit(PurchaseListEditorLoadingState());

    final result = await removePurchaseItemUsecase(event.id);
    result.fold(
      (failure) =>
          emit(PurchaseListEditorErrorState(message: failure.toString())),
      (success) {
        // ✅ EFFICIENT: Update existing loaded state by removing item
        final currentItems = currentState.purchaseList?.purchaseItems ?? [];
        final updatedItems =
            currentItems.where((item) => item.id != event.id).toList();
        final updatedPurchaseList =
            currentState.purchaseList?.copyWith(purchaseItems: updatedItems);

        emit(currentState.copyWith(purchaseList: updatedPurchaseList));

        // 🔥 Fire existing BLoC event to notify main purchase list page to refresh
        _eventBus.fire(RemoveItemFromPurchaseListEvent(id: event.id));
      },
    );
  }

  FutureOr<void> _onUpdatePurchaseItem(UpdatePurchaseItemEvent event,
      Emitter<PurchaseListEditorState> emit) async {
    if (state is! PurchaseListEditorLoadedState) {
      emit(PurchaseListEditorErrorState(
          message: 'Cannot update item: editor not loaded'));
      return;
    }

    final currentState = state as PurchaseListEditorLoadedState;
    // emit(PurchaseListEditorLoadingState());

    final result = await updatePurchaseItemUsecase(event.item);
    result.fold(
      (failure) =>
          emit(PurchaseListEditorErrorState(message: failure.toString())),
      (updatedItem) async {
        // ✅ EFFICIENT: Update existing loaded state by replacing the item
        final currentItems = currentState.purchaseList?.purchaseItems ?? [];
        final updatedItems = currentItems.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        final updatedPurchaseList =
            currentState.purchaseList?.copyWith(purchaseItems: updatedItems);

        emit(currentState.copyWith(purchaseList: updatedPurchaseList));

        // 🔧 FIX: Update purchase list completion status
        if (updatedPurchaseList != null) {
          await _updatePurchaseListCompletionStatus(updatedPurchaseList);
        }

        // 🔥 Fire existing BLoC event to notify main purchase list page to refresh
        _eventBus.fire(UpdatePurchaseItemEvent(item: updatedItem));
      },
    );
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }
}
