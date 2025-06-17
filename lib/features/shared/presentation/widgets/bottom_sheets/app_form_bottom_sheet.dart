import 'package:flutter/material.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';

/// Form-specific bottom sheet with consistent styling and layout
///
/// Extends [AppBottomSheet] to provide form capabilities with standardized
/// submit/cancel buttons and form validation handling.
class AppFormBottomSheet extends StatefulWidget {
  /// Title of the bottom sheet
  final String title;

  /// Form fields to be displayed in the bottom sheet
  final List<Widget> formFields;

  /// Global key for the form
  final GlobalKey<FormState> formKey;

  /// Callback when form is submitted (only called if validation passes)
  final VoidCallback onSubmit;

  /// Text to display on the submit button
  final String submitButtonText;

  /// Text to display on the cancel button
  final String cancelButtonText;

  /// Additional actions to show next to the default buttons
  final List<Widget>? additionalActions;

  /// Callback when form is canceled or dismissed
  final VoidCallback? onCancel;

  /// Whether the form is currently in a loading state
  final bool isLoading;

  const AppFormBottomSheet({
    Key? key,
    required this.title,
    required this.formFields,
    required this.formKey,
    required this.onSubmit,
    this.submitButtonText = 'SAVE',
    this.cancelButtonText = 'CANCEL',
    this.additionalActions,
    this.onCancel,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AppFormBottomSheet> createState() => _AppFormBottomSheetState();

  /// Static method to show a form bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget formBottomSheet,
  }) {
    return AppBottomSheet.show<T>(
      context: context,
      child: formBottomSheet,
    );
  }
}

class _AppFormBottomSheetState extends State<AppFormBottomSheet> {
  void _handleCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.of(context).pop();
  }

  void _handleSubmit() {
    if (widget.formKey.currentState!.validate()) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: widget.title,
      onDismiss: widget.onCancel,
      content: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.formFields.map((field) {
              // Add spacing between form fields
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: field,
              );
            }).toList(),
          ],
        ),
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Additional actions (if any)
          if (widget.additionalActions != null) ...widget.additionalActions!,
          // Cancel button
          TextButton(
            onPressed: widget.isLoading ? null : _handleCancel,
            child: Text(widget.cancelButtonText),
          ),
          const SizedBox(width: 16),
          // Submit button
          ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(widget.submitButtonText),
          ),
        ],
      ),
    );
  }
}
