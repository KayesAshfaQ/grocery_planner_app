import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';

import '../blocs/category_bloc.dart';
import '../widgets/add_category_bottom_sheet.dart';

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
  void _showAddCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddCategoryBottomSheet(
        onSave: (name, description, icon) {
          // Add your logic to save the new category
          print('Name: $name, Description: $description, Icon: $icon');
          // Example: addNewCategory(name, description, icon);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryBottomSheet,
          ),
        ],
      ),
      body: const Center(
        child: Text('Category Page'),
      ),
    );
  }
}
