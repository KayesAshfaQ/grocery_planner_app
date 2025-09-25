import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/catalog/presentation/blocs/catalog_bloc.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';

import '../widgets/catalog_item_form_bottom_sheet.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/dialogs/delete_confirmation_dialog.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  /// Route path for this page
  static const String routePath = '/catalog';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CatalogBloc>()..add(LoadCatalogsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>(),
        ),
      ],
      child: const CatalogPage(),
    );
  }

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  /// Shows a confirmation dialog for deleting a category (now uses shared widget)
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, CatalogItem item) async {
    final shouldDelete = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete Catalog Item',
      content:
          'Are you sure you want to delete "${item.name}"?\n\nThis action cannot be undone.',
    );
    if (shouldDelete == true && context.mounted) {
      context.read<CatalogBloc>().add(DeleteCatalogEvent(item.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              CatalogItemFormBottomSheet.showAdd(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CatalogLoaded) {
            final catalogs = state.catalogs;
            if (catalogs.isEmpty) {
              return const Center(child: Text('No catalogs found.'));
            }
            return ListView.builder(
              itemCount: catalogs.length,
              itemBuilder: (context, index) {
                final item = catalogs[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.category?.name ?? 'No Category'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          CatalogItemFormBottomSheet.showEdit(context, item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _showDeleteConfirmationDialog(context, item);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is CatalogError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(
              child: Text('Failed to load catalog'),
            );
          }
        },
      ),
    );
  }
}
