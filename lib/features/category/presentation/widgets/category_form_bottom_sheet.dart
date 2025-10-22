import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart'
    // ignore: library_prefixes
    as flutterIconPicker;
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:grocery_planner_app/flutter_iconpicker_packs/LineIcons/LineIcons.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/category/presentation/utils/category_icon_utils.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';

/// Configuration class for category form behavior
class CategoryFormConfig {
  final String title;
  final Category? initialCategory;
  final bool isEditMode;
  final String successMessage;

  const CategoryFormConfig._({
    required this.title,
    required this.isEditMode,
    required this.successMessage,
    this.initialCategory,
  });

  /// Factory constructor for add mode
  factory CategoryFormConfig.forAdd() {
    return const CategoryFormConfig._(
      title: 'Add New Category',
      isEditMode: false,
      successMessage: 'Category added successfully',
    );
  }

  /// Factory constructor for edit mode
  factory CategoryFormConfig.forEdit(Category category) {
    return CategoryFormConfig._(
      title: 'Edit Category',
      isEditMode: true,
      successMessage: 'Category updated successfully',
      initialCategory: category,
    );
  }
}

/// Unified category form widget supporting both add and edit modes
class CategoryFormBottomSheet extends StatefulWidget {
  final CategoryFormConfig config;

  const CategoryFormBottomSheet._({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<CategoryFormBottomSheet> createState() =>
      _CategoryFormBottomSheetState();

  /// Factory constructor for add mode
  factory CategoryFormBottomSheet.forAdd() {
    return CategoryFormBottomSheet._(
      config: CategoryFormConfig.forAdd(),
    );
  }

  /// Factory constructor for edit mode
  factory CategoryFormBottomSheet.forEdit(Category category) {
    return CategoryFormBottomSheet._(
      config: CategoryFormConfig.forEdit(category),
    );
  }

  /// Show add category bottom sheet
  static Future<void> showAdd(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: CategoryFormBottomSheet.forAdd(),
      ),
    );
  }

  /// Show edit category bottom sheet
  static Future<void> showEdit(BuildContext context, Category category) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: CategoryFormBottomSheet.forEdit(category),
      ),
    );
  }
}

class _CategoryFormBottomSheetState extends State<CategoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeIcon();
  }

  /// Initialize text controllers with initial values for edit mode
  void _initializeControllers() {
    final category = widget.config.initialCategory;
    _nameController = TextEditingController(text: category?.name ?? '');
    _descriptionController =
        TextEditingController(text: category?.description ?? '');
  }

  /// Initialize icon from category data for edit mode
  void _initializeIcon() {
    final category = widget.config.initialCategory;
    if (category?.imageUri != null) {
      _selectedIcon = CategoryIconUtils.parseIconFromUri(category!.imageUri);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Handle icon picker selection
  Future<void> _pickIcon() async {
    var icon = await flutterIconPicker.showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        // Option A: use generated enum pack if available
        iconPackModes: [flutterIconPicker.IconPack.lineAwesomeIcons],

        // Option B: use the generated Map directly as a custom pack
        // iconPackModes: [flutterIconPicker.IconPack.custom],
        customIconPack: lineAwesomeIcons,

        showTooltips: true,
        adaptiveDialog: true,
      ),
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon.data;
      });
    }
  }

  /// Remove selected icon
  void _removeIcon() {
    setState(() {
      _selectedIcon = null;
    });
  }

  /// Handle form submission for both add and edit modes
  void _handleSubmit() {
    final categoryName = _nameController.text.trim();
    final category = Category(
      id: widget.config.isEditMode ? widget.config.initialCategory?.id : null,
      name: categoryName,
      description: _descriptionController.text.trim(),
      imageUri: CategoryIconUtils.iconToUri(_selectedIcon),
    );

    // Emit appropriate BLoC event based on mode
    if (widget.config.isEditMode) {
      context.read<CategoryBloc>().add(UpdateCategoryEvent(category));
    } else {
      context.read<CategoryBloc>().add(AddCategoryEvent(category));
    }

    context.pop();

    // Show success message
    AppToast.showSuccess(context, widget.config.successMessage);
  }

  /// Build icon selection widget
  Widget _buildIconSelector() {
    return Row(
      children: [
        Text(
          'Category Icon (Optional):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: _pickIcon,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _selectedIcon != null
                ? Icon(_selectedIcon, size: 30)
                : const Text('Select Icon'),
          ),
        ),
        if (_selectedIcon != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.clear, size: 16),
            onPressed: _removeIcon,
            tooltip: 'Remove icon',
          ),
        ],
      ],
    );
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
              return 'Please enter a category name';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            border: OutlineInputBorder(),
            hintText: 'Enter a description...',
          ),
          maxLines: 2,
        ),
        _buildIconSelector(),
      ],
    );
  }
}
