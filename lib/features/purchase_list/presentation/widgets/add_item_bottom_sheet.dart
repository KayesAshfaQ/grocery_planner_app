import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';

class AddItemBottomSheet extends StatefulWidget {
  /// The purchase list id to add items to
  final int? listId;

  const AddItemBottomSheet({
    Key? key,
    this.listId,
  }) : super(key: key);

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();

  /// Show this bottom sheet
  static Future<void> show(BuildContext context, {int? listId}) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<PurchaseListEditorBloc>(),
        child: AddItemBottomSheet(listId: listId),
      ),
    );
  }
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  CatalogItem? _selectedCatalogItem;
  List<CatalogItem> _filteredCatalogItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final state = context.read<PurchaseListEditorBloc>().state;
    if (state is PurchaseListEditorLoadedState) {
      setState(() {
        if (_searchController.text.isEmpty) {
          _filteredCatalogItems = state.catalogItems;
        } else {
          _filteredCatalogItems = state.catalogItems
              .where((item) => item.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  void _onCatalogItemSelected(CatalogItem item) {
    setState(() {
      _selectedCatalogItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseListEditorBloc, PurchaseListEditorState>(
      builder: (context, state) {
        if (state is PurchaseListEditorLoadedState) {
          // Initialize filtered items if not done yet
          if (_filteredCatalogItems.isEmpty && _searchController.text.isEmpty) {
            _filteredCatalogItems = state.catalogItems;
          }

          return AppBottomSheet(
            title: 'Add New Item',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search field for catalog items
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search catalog items',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),

                // Catalog items list
                if (_filteredCatalogItems.isNotEmpty) ...[
                  Text(
                    'Select from catalog:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200, // Limit the ListView height
                    ),
                    child: ListView.builder(
                      itemCount: _filteredCatalogItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredCatalogItems[index];
                        final isSelected = _selectedCatalogItem?.id == item.id;

                        return ListTile(
                          dense: true,
                          // leading: CircleAvatar(
                          //   backgroundImage: item.imageUrl != null
                          //       ? NetworkImage(item.imageUrl!)
                          //       : null,
                          //   child: item.imageUrl == null
                          //       ? Text(item.name[0].toUpperCase())
                          //       : null,
                          // ),
                          title: Text(item.name),
                          subtitle: Text(
                            'Unit: ${item.defaultUnit ?? 'pcs'}',
                          ),
                          selected: isSelected,
                          selectedTileColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          onTap: () => _onCatalogItemSelected(item),
                          trailing: isSelected
                              ? Icon(Icons.check,
                                  color: Theme.of(context).primaryColor)
                              : null,
                        );
                      },
                    ),
                  ),
                ],

                if (_selectedCatalogItem != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Using catalog item: ${_selectedCatalogItem!.name}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCatalogItem = null;
                            });
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  child: const Text('ADD ITEM'),
                ),
              ],
            ),
          );
        }

        return const AppBottomSheet(
          title: 'Add New Item',
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
