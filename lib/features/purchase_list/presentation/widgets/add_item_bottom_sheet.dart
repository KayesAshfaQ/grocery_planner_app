import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _unitController = TextEditingController(text: 'pcs');
  final TextEditingController _priceController = TextEditingController();

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
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
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
              .where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  void _onCatalogItemSelected(CatalogItem item) {
    setState(() {
      _selectedCatalogItem = item;
      _nameController.text = item.name;
      _unitController.text = item.defaultUnit ?? 'pcs';
    });
  }

  void _handleAddItem() {
    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 1.0;
    final unit = _unitController.text.trim();
    final unitPrice = double.tryParse(_priceController.text);

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an item name')),
      );
      return;
    }

    // Ensure we have a valid listId
    if (widget.listId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No list selected')),
      );
      return;
    }

    final newItem = PurchaseItem(
      listId: widget.listId!,
      catalogItem: _selectedCatalogItem,
      customName: _selectedCatalogItem == null ? name : null,
      quantity: quantity,
      unitPrice: unitPrice,
      isPurchased: false,
      note: unit.isNotEmpty ? 'Unit: $unit' : null,
    );

    context.read<PurchaseListEditorBloc>().add(
          AddItemToPurchaseListEvent(item: newItem),
        );

    context.pop();
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
            content: SingleChildScrollView(
              child: Column(
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
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _filteredCatalogItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredCatalogItems[index];
                          final isSelected = _selectedCatalogItem?.id == item.id;

                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                              'Unit: ${item.defaultUnit ?? 'pcs'}',
                            ),
                            selected: isSelected,
                            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            onTap: () => _onCatalogItemSelected(item),
                            trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // Custom item form
                  Text(
                    'Item details:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _unitController,
                          decoration: const InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Unit Price (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  if (_selectedCatalogItem != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Using catalog item: ${_selectedCatalogItem!.name}',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedCatalogItem = null;
                                _nameController.clear();
                                _unitController.text = 'pcs';
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
            ),
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleAddItem,
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
