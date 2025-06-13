// filepath: /home/asfakul-kays/development/flutter/grocery_planner_app/lib/config/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/category/presentation/pages/category_page.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/pages/dashboard.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/pages/purchase_list_editor_page.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/pages/reports_page.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/pages/catalog_page.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/pages/purchase_list_page.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/pages/schedule_page.dart';

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

/// Application router configuration using go_router
///
/// This class defines all the routes available in the application
/// and provides navigation-related utilities.
class AppRouter {
  /// Creates the router configuration
  static GoRouter get router => _router;

  /// Private router instance
  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: PurchaseListPage.routePath,
    debugLogDiagnostics: true,
    routes: [
      // Main stateful shell route for the bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
          // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
          return Dashboard(navigationShell: navigationShell);
        },
        branches: [
          // Purchase List Branch
          StatefulShellBranch(
            navigatorKey: _sectionNavigatorKey,
            routes: [
              // Main route for the Purchase List
              GoRoute(
                path: PurchaseListPage.routePath,
                builder: (context, state) => const PurchaseListShell(),
                routes: [
                  // Route for Purchase List Editor
                  GoRoute(
                    path: PurchaseListEditorPage.routePath,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return PurchaseListEditorPage.create();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Catalog Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CatalogPage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CatalogPage(),
                ),
              ),
            ],
          ),

          // Category Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CategoryPage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CategoryPage(),
                ),
              ),
            ],
          ),

          // Schedule Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SchedulePage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SchedulePage(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      return Scaffold(
                        body: Center(
                          child: Text('Schedule Detail Screen for ID: $id - Implement me'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Reports Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ReportsPage.routePath,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ReportsPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'price-history/:itemId',
                    builder: (context, state) {
                      final itemId = state.pathParameters['itemId'];
                      return Scaffold(
                        body: Center(
                          child: Text('Price History Screen for Item ID: $itemId - Implement me'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}

/// A simple wrapper for the PurchaseListPage with BlocProvider
class PurchaseListShell extends StatelessWidget {
  const PurchaseListShell({super.key});

  @override
  Widget build(BuildContext context) {
    return PurchaseListPage.create();
  }
}
