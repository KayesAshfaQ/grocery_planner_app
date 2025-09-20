import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';

import '../blocs/category_bloc.dart';
import '../utils/category_icon_utils.dart';
import '../widgets/category_form_bottom_sheet.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  /// Route path for this page
  static const String routePath = '/categories';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create() {
    return BlocProvider(
      create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
      child: const CategoryPage(),
    );
  }

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  /// Shows the add category bottom sheet
  void _showAddCategoryBottomSheet(BuildContext context) {
    CategoryFormBottomSheet.showAdd(context);
  }

  /// Shows the edit category bottom sheet
  void _showEditCategoryBottomSheet(BuildContext context, Category category) {
    CategoryFormBottomSheet.showEdit(context, category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryBottomSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            final categories = state.categories;
            if (categories.isEmpty) {
              return const Center(child: Text('No categories found.'));
            }
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                // Parse category icon or use default
                final categoryIcon =
                    CategoryIconUtils.parseIconFromUri(category.imageUri) ??
                        Icons.category;

                return ListTile(
                  leading: Icon(categoryIcon),
                  title: Text(category.name ?? 'Unnamed Category'),
                  subtitle: Text(category.description ?? ''),
                  trailing: Icon(Icons.edit_outlined),
                  onTap: () {
                    // Handle category tap - open edit bottom sheet
                    _showEditCategoryBottomSheet(context, category);
                  },
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(
            child: Text('Category Page'),
          );
        },
      ),
    );
  }
}
