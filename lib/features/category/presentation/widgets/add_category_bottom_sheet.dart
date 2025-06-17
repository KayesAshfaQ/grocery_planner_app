import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as FlutterIconPicker;
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/config/theme/app_icons.dart';
import 'package:grocery_planner_app/features/category/presentation/blocs/category_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_form_bottom_sheet.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  // final Function(String name, String description, IconData? icon) onSave;

  const AddCategoryBottomSheet({
    Key? key,
    // required this.onSave,
  }) : super(key: key);

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();

  /// Show this bottom sheet
  static Future<void> show(BuildContext context) {
    return AppFormBottomSheet.show(
      context: context,
      formBottomSheet: BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: const AddCategoryBottomSheet(),
      ),
    );
  }
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  IconData? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    var icon = await FlutterIconPicker.showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        // iconPackModes: kReleaseMode ? [FlutterIconPicker.IconPack.material] : [],
        customIconPack: kDebugMode ? AppIcons.foodIcons : null,
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

  void _handleSubmit() {
    context.read<CategoryBloc>().add(
          AddCategoryEvent(Category(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            imageUri: _selectedIcon != null ? '${_selectedIcon!.codePoint},${_selectedIcon!.fontFamily}' : null,
          )),
        );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormBottomSheet(
      title: 'Add New Category',
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
        Row(
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
                child: _selectedIcon != null ? Icon(_selectedIcon, size: 30) : const Text('Select Icon'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
