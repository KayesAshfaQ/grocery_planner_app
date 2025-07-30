import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/catalog/presentation/blocs/catalog_bloc.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';

class AddCatalogItemBottomSheet extends StatefulWidget {
  const AddCatalogItemBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCatalogItemBottomSheet> createState() => _AddCatalogItemBottomSheetState();

  /// Show this bottom sheet
  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CategoryBloc>(),
          ),
          BlocProvider.value(
            value: context.read<CatalogBloc>(),
          ),
        ],
        child: const AddCatalogItemBottomSheet(),
      ),
    );
  }
}

class _AddCatalogItemBottomSheetState extends State<AddCatalogItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _imageUriController = TextEditingController();
  Category? _selectedCategory;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    // Load categories when bottom sheet opens
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _barcodeController.dispose();
    _imageUriController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final catalogItem = CatalogItem(
      name: _nameController.text.trim(),
      defaultUnit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
      category: _selectedCategory,
      imageUri: _imageUriController.text.trim().isEmpty ? null : _imageUriController.text.trim(),
    );

    context.read<CatalogBloc>().add(AddCatalogEvent(catalogItem));

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.form(
      title: 'Add New Catalog Item',
      formKey: _formKey,
      onSubmit: _handleSubmit,
      formFields: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an item name';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _unitController,
          decoration: const InputDecoration(
            labelText: 'Default Unit (Optional)',
            border: OutlineInputBorder(),
            hintText: 'e.g., kg, liter, piece',
          ),
        ),
        TextFormField(
          controller: _barcodeController,
          decoration: const InputDecoration(
            labelText: 'Barcode (Optional)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: _imageUriController,
          decoration: const InputDecoration(
            labelText: 'Image URL (Optional)',
            border: OutlineInputBorder(),
            hintText: 'URL to item image',
          ),
        ),
        Text(
          'Category:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoaded) {
              _categories = state.categories;

              return DropdownButtonFormField<Category>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Select a category'),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name ?? 'Unnamed Category'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              );
            } else if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('Failed to load categories');
            }
          },
        ),
      ],
    );
  }
}
