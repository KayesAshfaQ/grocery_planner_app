import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/category.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';

/// Page for adding a new grocery item
class PurchaseListEditorPage extends StatefulWidget {
  /// Creates a new add grocery item page
  const PurchaseListEditorPage({Key? key}) : super(key: key);

  /// Route path for this page (relative to parent)
  static const String routePath = 'editor';

  @override
  State<PurchaseListEditorPage> createState() => _PurchaseListEditorPageState();
}

class _PurchaseListEditorPageState extends State<PurchaseListEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _currencyController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _currencyController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onCatalogItemSelected(PurchaseListEditorBloc editorBloc, CatalogItem? item) {
    if (item == null) return;

    editorBloc.add(SelectCatalogItemEvent(catalogItem: item));

    _nameController.text = item.name;
    _unitController.text = item.defaultUnit ?? '';
    // _priceController.text = item.averagePrice.toString();
    // editorBloc.add(FindCategoryByIdEvent(categoryId: item.categoryId));
  }

  void _submitForm(BuildContext context, PurchaseListEditorLoadedState state) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text;
    final budget = double.tryParse(_budgetController.text) ?? 0.0;
    final currency = _currencyController.text;
    final note = _noteController.text;

    context.read<PurchaseListEditorBloc>().add(
          AddPurchaseListEvent(
            list: PurchaseList(
              name: name,
              budget: budget,
              currencySymbol: currency,
              note: note,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PurchaseListEditorBloc>()..add(LoadCategoriesAndCatalogItemsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Shopping List'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<PurchaseListEditorBloc, PurchaseListEditorState>(
          listener: (context, state) {
            if (state is PurchaseItemAddedState) {
              // Notify the grocery list to refresh before popping
              final groceryBloc = context.read<PurchaseListBloc>();
              groceryBloc.add(GetAllPurchaseItemsEvent());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grocery item added successfully')),
              );
              context.pop(context);
            } else if (state is PurchaseListAddedState) {
              // Notify the purchase list to refresh before popping
              final purchaseBloc = context.read<PurchaseListBloc>();
              purchaseBloc.add(GetAllPurchaseItemsEvent());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Purchase list added successfully')),
              );
              context.pop(context);
            } else if (state is PurchaseListEditorErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is PurchaseListEditorLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PurchaseListEditorLoadedState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildNameField(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildBudgetField(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: _buildCurrencyField(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildNoteField(),
                      const SizedBox(height: 16),

                      /// -------------- Add Purchase Item Section --------------
                      Row(
                        children: [
                          Text(
                            'Add New Item',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.add_circle_outline, color: Colors.green),
                        ],
                      ),
                      (state.purchaseItems == null || state.purchaseItems?.isEmpty == true)
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No items added yet. Tap + to add items.'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.purchaseItems?.length,
                              itemBuilder: (context, index) {
                                final item = state.purchaseItems?[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    title: Text(item?.customName ?? item?.catalogItem?.name ?? 'Unknown Item'),
                                    subtitle: Text(
                                      '${item?.quantity} pc - ${item?.unitPrice != null ? '\$${item?.unitPrice}' : 'No price set'}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () {
                                        context.read<PurchaseListEditorBloc>().add(
                                              RemoveItemFromPurchaseListEvent(id: item!.id!),
                                            );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state is PurchaseListEditorLoadingState ? null : () => _submitForm(context, state),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is PurchaseListEditorLoadingState
                            ? const CircularProgressIndicator()
                            : const Text('ADD SHOPPING LIST'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Fallback for initial state or error state
            return const Center(
              child: Text('Failed to load editor. Please try again.'),
            );
          },
        ),
      ),
    );
  }

  // Add this method to your _PurchaseListEditorPageState class

void _showAddItemDialog(BuildContext context, PurchaseListEditorLoadedState state) {
  final nameController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitController = TextEditingController(text: 'pcs');
  final priceController = TextEditingController();
  CatalogItem? selectedCatalogItem;
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<CatalogItem?>(
                decoration: const InputDecoration(
                  labelText: 'Select Item (Optional)',
                ),
                value: null,
                items: [
                  const DropdownMenuItem<CatalogItem?>(
                    value: null,
                    child: Text('-- Custom Item --'),
                  ),
                  ...state.catalogItems.map((item) {
                    return DropdownMenuItem<CatalogItem>(
                      value: item,
                      child: Text(item.name),
                    );
                  }),
                ],
                onChanged: (value) {
                  selectedCatalogItem = value;
                  if (value != null) {
                    nameController.text = value.name;
                    unitController.text = value.defaultUnit ?? 'pcs';
                  }
                },
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Unit Price (Optional)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final quantity = double.tryParse(quantityController.text) ?? 1.0;
              final unit = unitController.text;
              final unitPrice = double.tryParse(priceController.text);
              
              // if (name.isNotEmpty) {
              //   final newItem = PurchaseItem(
              //     catalogId: selectedCatalogItem?.id,
              //     catalogItem: selectedCatalogItem,
              //     customName: selectedCatalogItem == null ? name : null,
              //     quantity: quantity,
              //     unit: unit,
              //     unitPrice: unitPrice, listId: state.id,
              //   );
                
              //   context.read<PurchaseListEditorBloc>().add(
              //     AddItemToPurchaseListEvent(item: newItem),
              //   );
                
              //   Navigator.pop(context);
              // }
            },
            child: const Text('ADD'),
          ),
        ],
      );
    },
  );
}

  Widget _buildCatalogItemDropdown(BuildContext context, PurchaseListEditorLoadedState state) {
    final editorBloc = context.read<PurchaseListEditorBloc>();
    return DropdownButtonFormField<CatalogItem?>(
      decoration: const InputDecoration(
        labelText: 'Select from Catalog (Optional)',
        border: OutlineInputBorder(),
      ),
      value: null,
      items: [
        const DropdownMenuItem<CatalogItem?>(
          value: null,
          child: Text('-- Create new item --'),
        ),
        ...state.catalogItems.map((item) {
          return DropdownMenuItem<CatalogItem>(
            value: item,
            child: Text(item.name),
          );
        }).toList(),
      ],
      onChanged: (item) => _onCatalogItemSelected(editorBloc, item),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'List Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a list name';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, PurchaseListEditorLoadedState state) {
    final editorBloc = context.read<PurchaseListEditorBloc>();
    return Autocomplete<Category>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return state.categories;
        }
        return state.categories
            .where((category) => category.name?.toLowerCase().contains(textEditingValue.text.toLowerCase()) ?? false);
      },
      onSelected: (Category selectedCategory) {
        editorBloc.add(SelectCategoryEvent(category: selectedCategory));
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = state.selectedCategory?.name ?? '';
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (!state.categories.map((category) => category.name).contains(value)) {
              editorBloc.add(InsertCategoryEvent(name: value));
            }
          },
        );
      },
      optionsViewBuilder:
          (BuildContext context, AutocompleteOnSelected<Category> onSelected, Iterable<Category> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              height: 200,
              // child: ListView.builder(
              //   itemCount: options.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     final Category option = options.elementAt(index);
              //     return ListTile(
              //       title: Text(option.name),
              //       onTap: () => onSelected(option),
              //     );
              //   },
              // ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetField() {
    return TextFormField(
      controller: _budgetController,
      decoration: const InputDecoration(
        labelText: 'Budget',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: const InputDecoration(
        labelText: 'Quantity',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyField() {
    return TextFormField(
      controller: _currencyController,
      decoration: const InputDecoration(
        labelText: 'Currency (USD, EUR, etc.)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildUnitField() {
    return TextFormField(
      controller: _unitController,
      decoration: const InputDecoration(
        labelText: 'Unit (kg, pcs, etc.)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Price per Unit (\$)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: 'Note (Optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }
}
