import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/grocery_item_editor_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/analytics_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/catalog_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/grocery_list_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/home_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/schedule_page.dart';

/// Application router configuration using go_router
///
/// This class defines all the routes available in the application
/// and provides navigation-related utilities.
class AppRouter {
  /// Creates the router configuration
  static GoRouter get router => _router;

  // Route names for the application
  /// Home screen route name
  static const String home = '/';

  /// Grocery list screen route name
  static const String groceryList = '/grocery-list';

  /// Add/edit grocery item screen route name
  static const String groceryItemEditor = '/grocery-item-editor';

  /// Schedule list screen route name
  static const String scheduleList = '/schedule-list';

  /// Add/edit schedule screen route name
  static const String scheduleDetail = '/schedule';

  /// Reports screen route name
  static const String reports = '/reports';

  /// Price history screen route name
  static const String priceHistory = '/price-history';

  /// Catalog screen route name
  static const String catalog = '/catalog';

  /// Private router instance
  static final _router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: groceryList,
        builder: (context, state) => const GroceryListPage(),
      ),
      GoRoute(
        path: groceryItemEditor,
        builder: (context, state) => const GroceryItemEditorPage(),
      ),
      GoRoute(
        path: scheduleList,
        builder: (context, state) => const SchedulePage(),
      ),
      GoRoute(
        path: '$scheduleDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
                child:
                    Text('Schedule Detail Screen for ID: $id - Implement me')),
          );
        },
      ),
      GoRoute(
        path: reports,
        builder: (context, state) => const AnalyticsPage(),
      ),
      GoRoute(
        path: '$priceHistory/:itemId',
        builder: (context, state) {
          final itemId = state.pathParameters['itemId'];
          return Scaffold(
            body: Center(
                child: Text(
                    'Price History Screen for Item ID: $itemId - Implement me')),
          );
        },
      ),
      GoRoute(
        path: catalog,
        builder: (context, state) => const CatalogPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
