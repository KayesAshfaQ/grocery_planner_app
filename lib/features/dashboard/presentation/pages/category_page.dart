import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/category/category_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  /// Route path for this page
  static const String routePath = '/categories';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget route() {
    return BlocProvider(
      create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
      child: const CategoryPage(),
    );
  }

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Category Page'),
    );
  }
}
