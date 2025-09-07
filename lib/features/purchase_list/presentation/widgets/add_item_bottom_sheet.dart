import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

import '../../../shared/presentation/widgets/toast/app_toast.dart';

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

  List<CatalogItem> _selectedCatalogItems = [];
  List<CatalogItem> _filteredCatalogItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeSelectedItems();
  }

  void _initializeSelectedItems() {
    final state = context.read<PurchaseListEditorBloc>().state;
    if (state is PurchaseListEditorLoadedState) {
      final purchaseListItems = state.purchaseList?.purchaseItems ?? [];
      final catalogItemsInList = purchaseListItems
          .map((purchaseItem) => purchaseItem.catalogItem)
          .where((catalogItem) => catalogItem != null)
          .cast<CatalogItem>()
          .toList();

      setState(() {
        _selectedCatalogItems = [...catalogItemsInList];
      });
    }
  }

  List<CatalogItem> _getNewCatalogItems() {
    final state = context.read<PurchaseListEditorBloc>().state;
    if (state is! PurchaseListEditorLoadedState) return [];

    final existingCatalogItems = state.purchaseList?.purchaseItems
            .map((purchaseItem) => purchaseItem.catalogItem)
            .where((catalogItem) => catalogItem != null)
            .cast<CatalogItem>()
            .toList() ??
        [];

    return _selectedCatalogItems
        .where((selectedItem) => !existingCatalogItems
            .any((existing) => existing.id == selectedItem.id))
        .toList();
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
        log('Filtered items count: ${_filteredCatalogItems.length}');
      });
    }
  }

  void _onCatalogItemSelected(CatalogItem item) {
    setState(() {
      if (_selectedCatalogItems.contains(item)) {
        _selectedCatalogItems.remove(item);
      } else {
        _selectedCatalogItems.add(item);
      }
    });
  }

  void _onAddItems() {
    if (_selectedCatalogItems.isEmpty || widget.listId == null) return;

    final state = context.read<PurchaseListEditorBloc>().state;
    if (state is! PurchaseListEditorLoadedState) return;

    // Get currently existing catalog items in the purchase list
    final existingCatalogItems = state.purchaseList?.purchaseItems
            .map((purchaseItem) => purchaseItem.catalogItem)
            .where((catalogItem) => catalogItem != null)
            .cast<CatalogItem>()
            .toList() ??
        [];

    // Only create purchase items for newly selected catalog items (not already in list)
    final newCatalogItems = _selectedCatalogItems
        .where((selectedItem) => !existingCatalogItems
            .any((existing) => existing.id == selectedItem.id))
        .toList();

    if (newCatalogItems.isEmpty) {
      AppToast.showInfo(context, 'All selected items are already in the list');
      context.pop();
      return;
    }

    // Create PurchaseItem objects from newly selected catalog items
    final purchaseItems = newCatalogItems.map((catalogItem) {
      return PurchaseItem(
        listId: widget.listId!,
        catalogItem: catalogItem,
        quantity: 1.0, // Default quantity
        isPurchased: false,
      );
    }).toList();

    // Dispatch the event to add multiple items
    context.read<PurchaseListEditorBloc>().add(
          AddMultipleItemsToPurchaseListEvent(items: purchaseItems),
        );

    // Show success message immediately (optimistic UI)
    final itemCount = newCatalogItems.length;
    // Show success message
    AppToast.showSuccess(context,
        'Successfully added $itemCount item${itemCount > 1 ? 's' : ''} to the list');

    // Close the bottom sheet
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseListEditorBloc, PurchaseListEditorState>(
      listener: (context, state) {
        if (state is PurchaseListEditorErrorState) {
          // Show error message
          AppToast.showError(context, 'Error: ${state.message}');
        }
        // Note: Success messages are now handled directly in _onAddItems method
        // following the efficient state management pattern
      },
      child: BlocBuilder<PurchaseListEditorBloc, PurchaseListEditorState>(
        builder: (context, state) {
          if (state is PurchaseListEditorLoadedState) {
            // Initialize filtered items if not done yet
            if (_filteredCatalogItems.isEmpty &&
                _searchController.text.isEmpty) {
              _filteredCatalogItems = state.catalogItems;
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height *
                    0.8, // Limit the ListView height
              ),
              child: AppBottomSheet(
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredCatalogItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredCatalogItems[index];
                            final isSelected =
                                _selectedCatalogItems.contains(item);

                            // Check if item is already in the purchase list
                            final state =
                                context.read<PurchaseListEditorBloc>().state;
                            final isAlreadyInList = state
                                    is PurchaseListEditorLoadedState &&
                                (state.purchaseList?.purchaseItems.any(
                                        (purchaseItem) =>
                                            purchaseItem.catalogItem?.id ==
                                            item.id) ??
                                    false);

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
                              title: Row(
                                children: [
                                  Expanded(child: Text(item.name)),
                                  if (isAlreadyInList)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'In List',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.orange),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(
                                'Unit: ${item.defaultUnit ?? 'pcs'}',
                              ),
                              selected: isSelected,
                              selectedTileColor: isAlreadyInList
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.1),
                              onTap: () => _onCatalogItemSelected(item),
                              trailing: isSelected
                                  ? Icon(
                                      isAlreadyInList
                                          ? Icons.check_circle
                                          : Icons.check,
                                      color: isAlreadyInList
                                          ? Colors.orange
                                          : Theme.of(context).primaryColor,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            // height: 200,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // icon empty state
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('No catalog items found.'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    if (_selectedCatalogItems.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final newItems = _getNewCatalogItems();
                                  final totalSelected =
                                      _selectedCatalogItems.length;
                                  final newCount = newItems.length;
                                  final existingCount =
                                      totalSelected - newCount;

                                  String text =
                                      '$totalSelected item${totalSelected > 1 ? 's' : ''} selected';
                                  if (existingCount > 0) {
                                    text +=
                                        ' ($newCount new, $existingCount already in list)';
                                  }

                                  return Text(
                                    text,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  );
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCatalogItems.clear();
                                });
                              },
                              child: const Text('Clear All'),
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
                      onPressed:
                          _selectedCatalogItems.isNotEmpty ? _onAddItems : null,
                      style: ButtonStyle(visualDensity: VisualDensity.compact),
                      child: Builder(
                        builder: (context) {
                          if (_selectedCatalogItems.isEmpty) {
                            return const Text('SELECT ITEMS TO ADD');
                          }

                          final newItems = _getNewCatalogItems();
                          final newItemCount = newItems.length;

                          if (newItemCount == 0) {
                            return const Text('ALL ITEMS ALREADY IN LIST');
                          }

                          return Text(
                              'ADD $newItemCount NEW ITEM${newItemCount > 1 ? 'S' : ''}');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const AppBottomSheet(
            title: 'Add New Item',
            content: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
