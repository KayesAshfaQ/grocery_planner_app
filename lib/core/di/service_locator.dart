import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_planner_app/core/db/app_database.dart';
import 'package:grocery_planner_app/features/home/presentation/blocs/grocery/grocery_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_planner_app/core/api/api_client.dart';
import 'package:grocery_planner_app/core/network/network_info.dart';
import 'package:grocery_planner_app/features/home/data/datasources/local/grocery_local_data_source.dart';
import 'package:grocery_planner_app/features/home/data/repositories/grocery_repository_impl.dart';
import 'package:grocery_planner_app/features/home/domain/repositories/grocery_repository.dart';
import 'package:grocery_planner_app/features/home/domain/usecases/grocery/get_grocery_item_usecase.dart';
import 'package:grocery_planner_app/features/home/domain/usecases/grocery/mark_item_as_purchased_usecase.dart';

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
  sl.registerLazySingleton<ApiClient>(
      () => ApiClient(dio: sl(), baseUrl: 'https://yourapi.com/api'));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Data sources
  sl.registerLazySingleton<GroceryLocalDataSource>(
    () => GroceryLocalDataSourceImpl(groceryItemDao: database.groceryItemDao),
  );

  // Repositories
  sl.registerLazySingleton<GroceryRepository>(
    () => GroceryRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetGroceryItemsUsecase(sl()));
  sl.registerLazySingleton(() => MarkItemAsPurchasedUsecase(sl()));

  // Blocs/Cubits
  sl.registerFactory(() => GroceryBloc(
        getGroceryItemsUsecase: sl(),
        markItemAsPurchasedUsecase: sl(),
      ));
}
