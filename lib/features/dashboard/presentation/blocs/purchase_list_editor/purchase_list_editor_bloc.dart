import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/category.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/catalog/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/categories/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/add_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/add_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/remove_purchase_item_usecase.dart';

part 'purchase_list_editor_event.dart';
part 'purchase_list_editor_state.dart';

/// BLoC for managing grocery item editor operations
class PurchaseListEditorBloc extends Bloc<PurchaseListEditorEvent, PurchaseListEditorState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetCatalogItemsUsecase getCatalogItemsUsecase;
  final AddPurchaseListUsecase addPurchaseListUsecase;
  final AddPurchaseItemUsecase addPurchaseItemUsecase;
  final RemovePurchaseItemUsecase removePurchaseItemUsecase;
  final AppEventBus _eventBus;

  /// Creates a new EditorBloc
  PurchaseListEditorBloc({
    required this.getCategoriesUsecase,
    required this.getCatalogItemsUsecase,
    required this.addPurchaseItemUsecase,
    required this.addPurchaseListUsecase,
    required this.removePurchaseItemUsecase,
    required AppEventBus eventBus,
  })  : _eventBus = eventBus,
        super(PurchaseListEditorInitialState()) {
    on<LoadCategoriesAndCatalogItemsEvent>(_onLoadCategoriesAndCatalogItems);
    on<SelectCatalogItemEvent>(_onSelectCatalogItem);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<FindCategoryByIdEvent>(_onFindCategoryById);
    on<InsertCategoryEvent>(_onInsertCategory);
    on<AddPurchaseListEvent>(_onAddPurchaseList);
    on<AddItemToPurchaseListEvent>(_onAddItemToPurchaseList);
    on<RemoveItemFromPurchaseListEvent>(_onRemoveItemFromPurchaseList);
  }

  FutureOr<void> _onLoadCategoriesAndCatalogItems(
    LoadCategoriesAndCatalogItemsEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    emit(PurchaseListEditorLoadingState());

    try {
      final categoriesResult = await getCategoriesUsecase();
      final catalogItemsResult = await getCatalogItemsUsecase();

      List<Category> categories = [];
      List<CatalogItem> catalogItems = [];

      catalogItemsResult.fold(
        (failure) => emit(PurchaseListEditorErrorState(message: 'Error loading catalog items: ${failure.message}')),
        (items) {
          catalogItems = items;
        },
      );

      categoriesResult.fold(
        (failure) => emit(PurchaseListEditorErrorState(message: 'Error loading categories: ${failure.message}')),
        (loadedCategories) {
          categories = loadedCategories;
        },
      );

      // Only emit the loaded state if we didn't emit an error state
      if (state is PurchaseListEditorLoadingState) {
        emit(PurchaseListEditorLoadedState(
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
      final category = currentState.categories.firstWhere((category) => category.id == event.categoryId);
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
      final updatedCategories = List<Category>.from(currentState.categories)..add(newCategory);
      emit(currentState.copyWith(categories: updatedCategories));
    }
  }

  FutureOr<void> _onAddItemToPurchaseList(
    AddItemToPurchaseListEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    emit(PurchaseListEditorLoadingState());
    final result = await addPurchaseItemUsecase(event.item);
    result.fold(
      (failure) => emit(PurchaseListEditorErrorState(message: failure.toString())),
      (purchaseItem) {
        emit(PurchaseItemAddedState(item: purchaseItem));
      },
    );
  }

  FutureOr<void> _onRemoveItemFromPurchaseList(
      RemoveItemFromPurchaseListEvent event, Emitter<PurchaseListEditorState> emit) async {
    if (state is PurchaseListEditorLoadedState) {
      final currentState = state as PurchaseListEditorLoadedState;
      final items = currentState.purchaseList?.purchaseItems;

      /// iterate through the purchase items and remove the item with the given ID
      /// If the item is not found, do nothing
      items?.removeWhere((item) => item.id == event.id);

      final result = await removePurchaseItemUsecase(event.id);
      result.fold(
        (failure) => emit(PurchaseListEditorErrorState(message: failure.toString())),
        (success) {
          emit(currentState.copyWith(purchaseList: currentState.purchaseList?.copyWith(purchaseItems: items)));
        },
      );
    }
  }

  FutureOr<void> _onAddPurchaseList(
    AddPurchaseListEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    emit(PurchaseListEditorLoadingState());
    final result = await addPurchaseListUsecase(event.list);
    result.fold(
      (failure) => emit(PurchaseListEditorErrorState(message: failure.toString())),
      (purchaseList) {
        // Notify other blocs about the new list through the event bus
        _eventBus.fire(event);
        emit(PurchaseListAddedState(list: purchaseList));
      },
    );
  }
}
