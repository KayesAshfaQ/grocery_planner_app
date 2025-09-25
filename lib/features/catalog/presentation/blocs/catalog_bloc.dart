import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/add_catalog_item_usecase.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/update_catalog_item_usecase.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/remove_catalog_item_usecase.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final AddCatalogItemUsecase addCatalogItemUsecase;
  final GetCatalogItemsUsecase getCatalogItemsUsecase;
  final UpdateCatalogItemUsecase updateCatalogItemUsecase;
  final RemoveCatalogItemUsecase removeCatalogItemUsecase;

  CatalogBloc({
    required this.addCatalogItemUsecase,
    required this.getCatalogItemsUsecase,
    required this.updateCatalogItemUsecase,
    required this.removeCatalogItemUsecase,
  }) : super(CatalogInitial()) {
    on<AddCatalogEvent>(_onAddCatalog);
    on<LoadCatalogsEvent>(_onLoadCatalogs);
    on<UpdateCatalogEvent>(_onUpdateCatalog);
    on<DeleteCatalogEvent>(_onDeleteCatalog);
  }
  Future<void> _onDeleteCatalog(
      DeleteCatalogEvent event, Emitter<CatalogState> emit) async {
    final result = await removeCatalogItemUsecase(event.catalogId);
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (_) {
        // ✅ EFFICIENT: Update existing loaded state by removing the item
        if (state is CatalogLoaded) {
          final currentState = state as CatalogLoaded;
          final updatedCatalogs = currentState.catalogs
              .where((catalog) => catalog.id != event.catalogId)
              .toList();
          emit(CatalogLoaded(updatedCatalogs));
        } else {
          add(LoadCatalogsEvent());
        }
      },
    );
  }

  Future<void> _onUpdateCatalog(
      UpdateCatalogEvent event, Emitter<CatalogState> emit) async {
    final result = await updateCatalogItemUsecase(event.catalog);
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (updatedCatalog) {
        if (state is CatalogLoaded) {
          final currentState = state as CatalogLoaded;
          final updatedCatalogs = currentState.catalogs
              .map((item) =>
                  item.id == updatedCatalog.id ? updatedCatalog : item)
              .toList();
          emit(CatalogLoaded(updatedCatalogs));
        } else {
          add(LoadCatalogsEvent());
        }
      },
    );
  }

  Future<void> _onAddCatalog(
      AddCatalogEvent event, Emitter<CatalogState> emit) async {
    final result = await addCatalogItemUsecase(event.catalog);
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (catalog) {
        if (state is CatalogLoaded) {
          final currentState = state as CatalogLoaded;
          final updatedCatalogs = [...currentState.catalogs, catalog];
          emit(CatalogLoaded(updatedCatalogs));
        } else {
          add(LoadCatalogsEvent());
        }
      },
    );
  }

  Future<void> _onLoadCatalogs(
      LoadCatalogsEvent event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    final result = await getCatalogItemsUsecase();
    result.fold(
      (failure) => emit(CatalogError(failure.toString())),
      (catalogs) => emit(CatalogLoaded(catalogs)),
    );
  }
}
