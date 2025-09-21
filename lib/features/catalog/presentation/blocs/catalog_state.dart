part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<CatalogItem> catalogs;

  CatalogLoaded(this.catalogs);

  @override
  List<Object?> get props => [catalogs];
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);

  @override
  List<Object?> get props => [message];
}
