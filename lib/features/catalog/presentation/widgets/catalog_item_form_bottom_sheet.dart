import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/catalog/presentation/blocs/catalog_bloc.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';

class CatalogItemFormConfig {
  final String title;
  final CatalogItem? initialItem;
  final bool isEditMode;
  final String successMessage;

  CatalogItemFormConfig({
    required this.title,
    this.initialItem,
    required this.isEditMode,
    required this.successMessage,
  });

  factory CatalogItemFormConfig.forAdd() => CatalogItemFormConfig(
        title: 'Add New Catalog Item',
        isEditMode: false,
        successMessage: 'Catalog item added successfully',
      );

  factory CatalogItemFormConfig.forEdit(CatalogItem item) =>
      CatalogItemFormConfig(
        title: 'Edit Catalog Item',
        initialItem: item,
        isEditMode: true,
        successMessage: 'Catalog item updated successfully',
      );
}

class CatalogItemFormBottomSheet extends StatefulWidget {
  final CatalogItemFormConfig config;

  const CatalogItemFormBottomSheet({Key? key, required this.config})
      : super(key: key);

  static Future<void> showAdd(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CategoryBloc>()),
          BlocProvider.value(value: context.read<CatalogBloc>()),
        ],
        child:
            CatalogItemFormBottomSheet(config: CatalogItemFormConfig.forAdd()),
      ),
    );
  }

  static Future<void> showEdit(BuildContext context, CatalogItem item) {
    return AppBottomSheet.show(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CategoryBloc>()),
          BlocProvider.value(value: context.read<CatalogBloc>()),
        ],
        child: CatalogItemFormBottomSheet(
            config: CatalogItemFormConfig.forEdit(item)),
      ),
    );
  }

  @override
  State<CatalogItemFormBottomSheet> createState() =>
      _CatalogItemFormBottomSheetState();
}

class _CatalogItemFormBottomSheetState
    extends State<CatalogItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _barcodeController;
  late TextEditingController _imageUriController;
  Category? _selectedCategory;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    final item = widget.config.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _unitController = TextEditingController(text: item?.defaultUnit ?? '');
    _barcodeController = TextEditingController(text: item?.barcode ?? '');
    _imageUriController = TextEditingController(text: item?.imageUri ?? '');
    _selectedCategory = item?.category;
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
    final catalogItem =
        (widget.config.isEditMode && widget.config.initialItem != null)
            ? widget.config.initialItem!.copyWith(
                name: _nameController.text.trim(),
                defaultUnit: _unitController.text.trim().isEmpty
                    ? null
                    : _unitController.text.trim(),
                barcode: _barcodeController.text.trim().isEmpty
                    ? null
                    : _barcodeController.text.trim(),
                category: _selectedCategory,
                imageUri: _imageUriController.text.trim().isEmpty
                    ? null
                    : _imageUriController.text.trim(),
              )
            : CatalogItem(
                name: _nameController.text.trim(),
                defaultUnit: _unitController.text.trim().isEmpty
                    ? null
                    : _unitController.text.trim(),
                barcode: _barcodeController.text.trim().isEmpty
                    ? null
                    : _barcodeController.text.trim(),
                category: _selectedCategory,
                imageUri: _imageUriController.text.trim().isEmpty
                    ? null
                    : _imageUriController.text.trim(),
              );

    if (widget.config.isEditMode) {
      context.read<CatalogBloc>().add(UpdateCatalogEvent(catalogItem));
    } else {
      context.read<CatalogBloc>().add(AddCatalogEvent(catalogItem));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.form(
      title: widget.config.title,
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
