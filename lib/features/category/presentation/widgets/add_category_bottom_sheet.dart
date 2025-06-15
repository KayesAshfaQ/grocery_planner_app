import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as FlutterIconPicker;
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:grocery_planner_app/config/theme/app_icons.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  final Function(String name, String description, IconData? icon) onSave;

  const AddCategoryBottomSheet({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        // Add padding to avoid keyboard overlap
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Enter a description...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        _nameController.text.trim(),
                        _descriptionController.text.trim(),
                        _selectedIcon,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
