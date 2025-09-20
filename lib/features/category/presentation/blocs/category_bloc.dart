import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/add_category_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/update_category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUsecase addCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final UpdateCategoryUsecase updateCategoryUsecase;

  CategoryBloc({
    required this.addCategoryUsecase,
    required this.deleteCategoryUsecase,
    required this.getCategoriesUsecase,
    required this.updateCategoryUsecase,
  }) : super(CategoryInitial()) {
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<UpdateCategoryEvent>(_onUpdateCategory);
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await addCategoryUsecase(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.toString())),
      (newCategory) {
        // ✅ EFFICIENT: Update existing loaded state directly
        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;
          final updatedCategories = [...currentState.categories, newCategory];
          emit(CategoryLoaded(updatedCategories));
        } else {
          // Fallback: Trigger full reload
          add(LoadCategoriesEvent());
        }
      },
    );
  }

  Future<void> _onLoadCategories(
      LoadCategoriesEvent event, Emitter<CategoryState> emit) async {
    // Only emit loading state if we don't have data yet
    if (state is! CategoryLoaded) {
      emit(CategoryLoading());
    }

    final result = await getCategoriesUsecase();
    result.fold(
      (failure) => emit(CategoryError(failure.toString())),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await updateCategoryUsecase(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.toString())),
      (updatedCategory) {
        // ✅ EFFICIENT: Update existing loaded state by replacing the item
        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;
          final updatedCategories = currentState.categories.map((category) {
            return category.id == updatedCategory.id
                ? updatedCategory
                : category;
          }).toList();
          emit(CategoryLoaded(updatedCategories));
        } else {
          // Fallback: Trigger full reload
          add(LoadCategoriesEvent());
        }
      },
    );
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    final result = await deleteCategoryUsecase(event.categoryId);
    result.fold(
      (failure) => emit(CategoryError(failure.toString())),
      (_) {
        // ✅ EFFICIENT: Update existing loaded state by removing the item
        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;
          final updatedCategories = currentState.categories
              .where((category) => category.id != event.categoryId)
              .toList();
          emit(CategoryLoaded(updatedCategories));
        } else {
          // Fallback: Trigger full reload
          add(LoadCategoriesEvent());
        }
      },
    );
  }
}
