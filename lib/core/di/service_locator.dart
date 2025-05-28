import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_planner_app/core/api/api_client.dart';
import 'package:grocery_planner_app/core/db/app_database.dart';
import 'package:grocery_planner_app/core/network/network_info.dart';
import 'package:grocery_planner_app/features/dashboard/data/datasources/catalog_data_source.dart';
import 'package:grocery_planner_app/features/dashboard/data/datasources/category_data_source.dart';
import 'package:grocery_planner_app/features/dashboard/data/datasources/purchase_data_source.dart';
import 'package:grocery_planner_app/features/dashboard/data/repositories/catalog_repository_impl.dart';
import 'package:grocery_planner_app/features/dashboard/data/repositories/category_repository_impl.dart';
import 'package:grocery_planner_app/features/dashboard/data/repositories/purchase_repository_impl.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/catalog_repository.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/category_repository.dart';
import 'package:grocery_planner_app/features/dashboard/domain/repositories/purchase_repository.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/catalog/get_catalog_items_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/categories/get_categories_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/add_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/add_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/get_purchase_list_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/mark_item_as_purchased_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/domain/usecases/grocery/remove_purchase_item_usecase.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

final sl = GetIt.instance;

/// Registers all dependencies for the app
Future<void> initServiceLocator(AppDatabase database) async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // API client with Dio
  final dio = Dio();
  // You can add interceptors here
  // dio.interceptors.add(LogInterceptor(responseBody: true));

  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dio: sl(), baseUrl: 'https://yourapi.com/api'));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Data sources
  sl.registerLazySingleton<PurchaseDataSource>(
    () => PurchaseLocalDataSourceImpl(purchaseDao: database.purchaseDao),
  );
  sl.registerLazySingleton<CatalogDataSource>(
    () => CatalogLocalDataSourceImpl(catalogItemDao: database.catalogItemDao),
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
  sl.registerLazySingleton(() => MarkItemAsPurchasedUsecase(sl()));
  sl.registerLazySingleton(() => AddPurchaseListUsecase(sl()));
  sl.registerLazySingleton(() => AddPurchaseItemUsecase(sl()));
  sl.registerLazySingleton(() => RemovePurchaseItemUsecase(sl()));
  sl.registerLazySingleton(() => GetCatalogItemsUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));

  // Blocs/Cubits
  sl.registerFactory(() => PurchaseListBloc(
        getPurchaseListUsecase: sl(),
        markItemAsPurchasedUsecase: sl(),
      ));

  sl.registerFactory(() => PurchaseListEditorBloc(
        getCategoriesUsecase: sl(),
        getCatalogItemsUsecase: sl(),
        addPurchaseListUsecase: sl(), 
        addPurchaseItemUsecase: sl(),
        removePurchaseItemUsecase: sl(),
      ));
}
