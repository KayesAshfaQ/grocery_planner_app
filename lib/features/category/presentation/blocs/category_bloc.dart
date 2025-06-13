import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/category/domain/entities/category.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/add_category_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/get_categories_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUsecase addCategoryUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;

  CategoryBloc({required this.addCategoryUsecase, required this.getCategoriesUsecase}) : super(CategoryInitial()) {
    on<AddCategoryEvent>(_onAddCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await addCategoryUsecase(event.category);
    result.fold(
      (failure) => emit(CategoryError( failure.toString())),
      (category) => emit(CategoryAdded(category: category)),
    );
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getCategoriesUsecase();
    result.fold(
      (failure) => emit(CategoryError(failure.toString())),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
