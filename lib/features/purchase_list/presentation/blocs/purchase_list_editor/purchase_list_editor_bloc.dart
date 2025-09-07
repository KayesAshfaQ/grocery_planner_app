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
  final RemovePurchaseItemUsecase removePurchaseItemUsecase;
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  /// Creates a new EditorBloc
  PurchaseListEditorBloc({
    required this.getPurchaseListUsecase,
    required this.getCategoriesUsecase,
    required this.getCatalogItemsUsecase,
    required this.addPurchaseItemUsecase,
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
    emit(PurchaseListEditorLoadingState());

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
    emit(PurchaseListEditorLoadingState());

    List<PurchaseItem> addedItems = [];
    List<String> errors = [];

    // Add each item one by one
    for (PurchaseItem item in event.items) {
      final result = await addPurchaseItemUsecase(item);
      result.fold(
        (failure) => errors.add(
            'Failed to add ${item.customName ?? item.catalogItem?.name ?? 'item'}: ${failure.message}'),
        (purchaseItem) => addedItems.add(purchaseItem),
      );
    }

    if (errors.isNotEmpty) {
      emit(PurchaseListEditorErrorState(message: errors.join('\n')));
    } else {
      // ✅ EFFICIENT: Update existing loaded state with new items
      final currentItems = currentState.purchaseList?.purchaseItems ?? [];
      final updatedItems = [...currentItems, ...addedItems];
      final updatedPurchaseList =
          currentState.purchaseList?.copyWith(purchaseItems: updatedItems);

      emit(currentState.copyWith(purchaseList: updatedPurchaseList));

      // Fire event through EventBus to notify other parts of the app (like the main purchase list)
      _eventBus.fire(AddMultipleItemsToPurchaseListEvent(items: addedItems));
    }
  }

  FutureOr<void> _onRemoveItemFromPurchaseList(
      RemoveItemFromPurchaseListEvent event,
      Emitter<PurchaseListEditorState> emit) async {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      final items = currentState.purchaseList?.purchaseItems;

      /// iterate through the purchase items and remove the item with the given ID
      /// If the item is not found, do nothing
      items?.removeWhere((item) => item.id == event.id);

      final result = await removePurchaseItemUsecase(event.id);
      result.fold(
        (failure) =>
            emit(PurchaseListEditorErrorState(message: failure.toString())),
        (success) {
          emit(currentState.copyWith(
              purchaseList:
                  currentState.purchaseList?.copyWith(purchaseItems: items)));
        },
      );
    }
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }
}
