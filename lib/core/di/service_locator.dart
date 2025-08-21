import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/add_catalog_item_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/remove_purchase_list_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_planner_app/core/api/api_client.dart';
import 'package:grocery_planner_app/core/db/app_database.dart';
import 'package:grocery_planner_app/core/event/app_event_bus.dart';
import 'package:grocery_planner_app/core/network/network_info.dart';
import 'package:grocery_planner_app/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:grocery_planner_app/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:grocery_planner_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:grocery_planner_app/features/catalog/domain/usecases/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/catalog/presentation/blocs/catalog_bloc.dart';
import 'package:grocery_planner_app/features/category/data/datasources/category_data_source.dart';
import 'package:grocery_planner_app/features/category/data/repositories/category_repository_impl.dart';
import 'package:grocery_planner_app/features/category/domain/repositories/category_repository.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/add_category_usecase.dart';
import 'package:grocery_planner_app/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/data/repositories/purchase_repository_impl.dart';
import 'package:grocery_planner_app/features/purchase_list/data/datasources/purchase_data_source.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/repositories/purchase_repository.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/add_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/add_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/mark_item_as_purchased_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/domain/usecases/remove_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

final sl = GetIt.instance;

/// Registers all dependencies for the app
Future<void> initServiceLocator(AppDatabase database) async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AppEventBus());

  // API client with Dio
  final dio = Dio();
  // You can add interceptors here
  // dio.interceptors.add(LogInterceptor(responseBody: true));

  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiClient>(
      () => ApiClient(dio: sl(), baseUrl: 'https://yourapi.com/api'));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Data sources
  sl.registerLazySingleton<PurchaseDataSource>(
    () => PurchaseLocalDataSourceImpl(purchaseDao: database.purchaseDao),
  );
  sl.registerLazySingleton<CatalogDataSource>(
    () => CatalogLocalDataSourceImpl(
        catalogItemDao: database.catalogItemDao, categoryDao: database.categoryDao),
  );
  sl.registerLazySingleton<CategoryDataSource>(
    () => CategoryLocalDataSourceImpl(categoryItemDao: database.categoryDao),
  );

  // Repositories
  sl.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPurchaseListUsecase(sl()));
  sl.registerLazySingleton(() => AddPurchaseListUsecase(sl()));
  sl.registerLazySingleton(() => RemovePurchaseListUsecase(sl()));

  sl.registerLazySingleton(() => AddPurchaseItemUsecase(sl()));
  sl.registerLazySingleton(() => MarkItemAsPurchasedUsecase(sl()));
  sl.registerLazySingleton(() => RemovePurchaseItemUsecase(sl()));

  sl.registerLazySingleton(() => GetCatalogItemsUsecase(sl()));
  sl.registerLazySingleton(() => AddCatalogItemUsecase(sl()));

  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(sl()));

  // Blocs/Cubits
  sl.registerFactory(() => PurchaseListBloc(
        getAllPurchaseListUseCase: sl(),
        addPurchaseListUsecase: sl(),
        removePurchaseListUsecase: sl(),
        eventBus: sl(),
      ));

  sl.registerFactory(() => PurchaseListEditorBloc(
        getPurchaseListUsecase: sl(),
        getCategoriesUsecase: sl(),
        getCatalogItemsUsecase: sl(),
        addPurchaseItemUsecase: sl(),
        removePurchaseItemUsecase: sl(),
        eventBus: sl(),
      ));

  sl.registerFactory(() => CategoryBloc(
        getCategoriesUsecase: sl(),
        addCategoryUsecase: sl(),
      ));

  sl.registerFactory(() => CatalogBloc(
        getCatalogItemsUsecase: sl(),
        addCatalogItemUsecase: sl(),
      ));
}
