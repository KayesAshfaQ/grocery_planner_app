import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/add_catalog_item_usecase.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/get_catalog_items_usecase.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final AddCatalogItemUsecase addCatalogItemUsecase;
  final GetCatalogItemsUsecase getCatalogItemsUsecase;

  CatalogBloc({required this.addCatalogItemUsecase, required this.getCatalogItemsUsecase}) : super(CatalogInitial()) {
    on<AddCatalogEvent>(_onAddCatalog);
    on<LoadCatalogsEvent>(_onLoadCatalogs);
  }

  Future<void> _onAddCatalog(AddCatalogEvent event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    final result = await addCatalogItemUsecase(event.catalog);
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (catalog) => emit(CatalogAdded(catalog: catalog)),
    );
  }

  Future<void> _onLoadCatalogs(LoadCatalogsEvent event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    final result = await getCatalogItemsUsecase();
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (catalogs) => emit(CatalogLoaded(catalogs)),
    );
  }
}
