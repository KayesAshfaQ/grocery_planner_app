import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grocery_planner_app/config/theme/app_theme.dart';
import 'package:grocery_planner_app/core/db/app_database.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize database
  final database =
      await $FloorAppDatabase.databaseBuilder('grocery_app.db').build();

  // Initialize service locator
  await initServiceLocator(database);

  runApp(const GroceryPlannerApp());
}

class GroceryPlannerApp extends StatelessWidget {
  const GroceryPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
