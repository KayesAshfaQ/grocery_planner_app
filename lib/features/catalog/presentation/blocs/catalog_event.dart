part of 'catalog_bloc.dart';

class CatalogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCatalogsEvent extends CatalogEvent {}

class AddCatalogEvent extends CatalogEvent {
  final CatalogItem catalog;

  AddCatalogEvent(this.catalog);

  @override
  List<Object?> get props => [catalog];
}

class DeleteCatalogEvent extends CatalogEvent {
  final int catalogId;

  DeleteCatalogEvent(this.catalogId);

  @override
  List<Object?> get props => [catalogId];
}

class UpdateCatalogEvent extends CatalogEvent {
  final CatalogItem catalog;

  UpdateCatalogEvent(this.catalog);

  @override
  List<Object?> get props => [catalog];
}
