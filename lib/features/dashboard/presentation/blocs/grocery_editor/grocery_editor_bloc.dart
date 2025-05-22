import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entity/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entity/category.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/catalog/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/categories/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/add_grocery_item_usecase.dart';

part 'grocery_editor_event.dart';
part 'grocery_editor_state.dart';

/// BLoC for managing grocery item editor operations
class GroceryEditorBloc extends Bloc<GroceryEditorEvent, GroceryEditorState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetCatalogItemsUsecase getCatalogItemsUsecase;
  final AddGroceryItemUsecase addGroceryItemUsecase;

  /// Creates a new EditorBloc
  GroceryEditorBloc({
    required this.getCategoriesUsecase,
    required this.getCatalogItemsUsecase,
    required this.addGroceryItemUsecase,
  }) : super(GroceryEditorInitialState()) {
    on<LoadCategoriesAndCatalogItemsEvent>(_onLoadCategoriesAndCatalogItems);
    on<SelectCatalogItemEvent>(_onSelectCatalogItem);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<FindCategoryByIdEvent>(_onFindCategoryById);
    on<InsertCategoryEvent>(_onInsertCategory);
    on<AddGroceryItemEvent>(_onAddGroceryItem);
  }

  FutureOr<void> _onLoadCategoriesAndCatalogItems(
    LoadCategoriesAndCatalogItemsEvent event,
    Emitter<GroceryEditorState> emit,
  ) async {
    emit(GroceryEditorLoadingState());

    try {
      final categoriesResult = await getCategoriesUsecase();
      final catalogItemsResult = await getCatalogItemsUsecase();

      List<Category> categories = [];
      Category? selectedCategory;
      List<CatalogItem> catalogItems = [];

      catalogItemsResult.fold(
        (failure) => emit(GroceryEditorErrorState(message: 'Error loading catalog items: ${failure.message}')),
        (items) => catalogItems = items,
      );

      categoriesResult.fold(
        (failure) => emit(GroceryEditorErrorState(message: 'Error loading categories: ${failure.message}')),
        (loadedCategories) {
          categories = loadedCategories;
          if (categories.isNotEmpty) {
            selectedCategory = categories.first;
          }
        },
      );

      // Only emit the loaded state if we didn't emit an error state
      if (state is GroceryEditorLoadingState) {
        emit(GroceryEditorLoadedState(
          categories: categories,
          catalogItems: catalogItems,
          selectedCategory: selectedCategory,
          selectedCatalogItem: null,
        ));
      }
    } catch (e) {
      emit(GroceryEditorErrorState(message: 'Unexpected error: $e'));
    }
  }

  FutureOr<void> _onSelectCatalogItem(
    SelectCatalogItemEvent event,
    Emitter<GroceryEditorState> emit,
  ) {
    if (state is GroceryEditorLoadedState) {
      final currentState = state as GroceryEditorLoadedState;
      emit(currentState.copyWith(selectedCatalogItem: event.catalogItem));
    }
  }

  FutureOr<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<GroceryEditorState> emit,
  ) {
    if (state is GroceryEditorLoadedState) {
      final currentState = state as GroceryEditorLoadedState;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  FutureOr<void> _onFindCategoryById(
    FindCategoryByIdEvent event,
    Emitter<GroceryEditorState> emit,
  ) async {
    if (state is GroceryEditorLoadedState) {
      final currentState = state as GroceryEditorLoadedState;
      final category = currentState.categories.firstWhere((category) => category.id == event.categoryId);
      emit(currentState.copyWith(selectedCategory: category));
    }
  }

  FutureOr<void> _onInsertCategory(
    InsertCategoryEvent event,
    Emitter<GroceryEditorState> emit,
  ) async {
    if (state is GroceryEditorLoadedState) {
      final currentState = state as GroceryEditorLoadedState;
      final newCategory = Category(name: event.name);
      final updatedCategories = List<Category>.from(currentState.categories)..add(newCategory);
      emit(currentState.copyWith(categories: updatedCategories));
    }
  }

  FutureOr<void> _onAddGroceryItem(
    AddGroceryItemEvent event,
    Emitter<GroceryEditorState> emit,
  ) async {
    emit(GroceryEditorLoadingState());
    final result = await addGroceryItemUsecase(event.item);
    result.fold(
      (failure) => emit(GroceryEditorErrorState(message: failure.toString())),
      (groceryItem) {
        emit(GroceryAddedState(item: groceryItem));
      },
    );
  }
}
