import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/grocery_item.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/grocery/grocery_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/grocery_editor/grocery_editor_bloc.dart';

/// Page for adding a new grocery item
class GroceryItemEditorPage extends StatefulWidget {
  /// Creates a new add grocery item page
  const GroceryItemEditorPage({Key? key}) : super(key: key);

  /// Route path for this page (relative to parent)
  static const String routePath = 'editor';

  @override
  State<GroceryItemEditorPage> createState() => _GroceryItemEditorPageState();
}

class _GroceryItemEditorPageState extends State<GroceryItemEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onCatalogItemSelected(GroceryEditorBloc editorBloc, CatalogItem? item) {
    if (item == null) return;

    editorBloc.add(SelectCatalogItemEvent(catalogItem: item));

    _nameController.text = item.name;
    _unitController.text = item.defaultUnit;
    _priceController.text = item.averagePrice.toString();
    editorBloc.add(SelectCategoryEvent(category: item.category));
  }

  void _submitForm(BuildContext context, GroceryEditorLoadedState state) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text;
    final category = state.selectedCategory!;
    final quantity = double.parse(_quantityController.text);
    final unit = _unitController.text;
    final price = double.parse(_priceController.text);
    final note = _noteController.text;

    context.read<GroceryEditorBloc>().add(
          AddGroceryItemEvent(
            item: GroceryItem(
              id: const Uuid().v4(),
              name: name,
              category: category,
              quantity: quantity,
              unit: unit,
              unitPrice: price,
              note: note,
              createdAt: DateTime.now(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroceryEditorBloc>()..add(LoadCategoriesAndCatalogItemsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Grocery Item'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<GroceryEditorBloc, GroceryEditorState>(
          listener: (context, state) {
            if (state is GroceryAddedState) {
              // Notify the grocery list to refresh before popping
              final groceryBloc = context.read<GroceryBloc>();
              groceryBloc.add(GetAllGroceryItemsEvent());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grocery item added successfully')),
              );
              Navigator.pop(context);
            } else if (state is GroceryEditorErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            } else if (state is GroceryEditorErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is GroceryEditorLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroceryEditorLoadedState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCatalogItemDropdown(context, state),
                      const SizedBox(height: 24),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(context, state),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildQuantityField(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: _buildUnitField(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPriceField(),
                      const SizedBox(height: 16),
                      _buildNoteField(),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: state is GroceryEditorLoadingState ? null : () => _submitForm(context, state),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is GroceryEditorLoadingState ? const CircularProgressIndicator() : const Text('ADD TO SHOPPING LIST'),
                      )
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

  Widget _buildCatalogItemDropdown(BuildContext context, GroceryEditorLoadedState state) {
    final editorBloc = context.read<GroceryEditorBloc>();
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
        labelText: 'Item Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an item name';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, GroceryEditorLoadedState state) {
    final editorBloc = context.read<GroceryEditorBloc>();
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return state.categories;
        }
        return state.categories.where((category) => category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selectedCategory) {
        editorBloc.add(SelectCategoryEvent(category: selectedCategory));
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        textEditingController.text = state.selectedCategory ?? '';
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (!state.categories.contains(value)) {
              editorBloc.add(SelectCategoryEvent(category: value));
            }
          },
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
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
