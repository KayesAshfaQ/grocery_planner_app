part of 'category_bloc.dart';

class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryAdded extends CategoryState {
  final Category category;

  CategoryAdded({required this.category});

  @override
  List<Object?> get props => [category];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
