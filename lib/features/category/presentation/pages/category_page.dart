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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => AddCategoryBottomSheet.show(context),
          ),
        ],
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) => current is CategoryAdded,
        listener: (context, state) {
          if (state is CategoryAdded) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category "${state.category.name}" added successfully')),
            );

            // Reload categories when a new category is added
            context.read<CategoryBloc>().add(LoadCategoriesEvent());
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
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
                  return ListTile(
                    leading: Icon(Icons.category),
                    title: Text(category.name ?? 'Unnamed Category'),
                    subtitle: Text(category.description ?? ''),
                    onTap: () {
                      // Handle category tap
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
      ),
    );
  }
}
