import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_planner_app/core/api/api_client.dart';
import 'package:grocery_planner_app/core/network/network_info.dart';

final serviceLocator = GetIt.instance;

/// Registers all dependencies for the app
Future<void> initServiceLocator() async {
  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  // API client with Dio
  final dio = Dio();
  // You can add interceptors here
  // dio.interceptors.add(LogInterceptor(responseBody: true));

  serviceLocator.registerLazySingleton<Dio>(() => dio);
  serviceLocator.registerLazySingleton<ApiClient>(() =>
      ApiClient(dio: serviceLocator(), baseUrl: 'https://yourapi.com/api'));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => Connectivity());

  // Data sources
  
  // Repositories
  
}
