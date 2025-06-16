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

class CatalogAdded extends CatalogState {
  final CatalogItem catalog;

  CatalogAdded({required this.catalog});

  @override
  List<Object?> get props => [catalog];
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);

  @override
  List<Object?> get props => [message];
}
