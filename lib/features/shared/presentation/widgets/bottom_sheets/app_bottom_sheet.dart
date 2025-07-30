import 'package:flutter/material.dart';

/// Unified bottom sheet with consistent styling and layout
///
/// This widget provides a standardized bottom sheet design for the app,
/// handling padding, title styling, and basic layout structure.
/// Supports both regular content and form layouts with built-in validation.
class AppBottomSheet extends StatefulWidget {
  /// Title of the bottom sheet
  final String title;

  /// Main content area of the bottom sheet
  /// If [formFields] is provided, this will be ignored
  final Widget? content;

  /// Form fields to be displayed in the bottom sheet
  /// If provided, will automatically wrap in Form widget
  final List<Widget>? formFields;

  /// Global key for the form (required if using formFields)
  final GlobalKey<FormState>? formKey;

  /// Optional footer actions (typically buttons)
  /// If null, no footer will be displayed
  final Widget? actions;

  /// Callback when form is submitted (only for form mode)
  final VoidCallback? onSubmit;

  /// Text to display on the submit button (form mode only)
  final String submitButtonText;

  /// Text to display on the cancel button (form mode only)
  final String cancelButtonText;

  /// Whether the form is currently in a loading state (form mode only)
  final bool isLoading;

  /// Controls if bottom sheet should size to fit content
  final bool isScrollControlled;

  /// Callback when user attempts to dismiss the sheet
  final VoidCallback? onDismiss;

  const AppBottomSheet({
    Key? key,
    required this.title,
    this.content,
    this.actions,
    this.isScrollControlled = true,
    this.onDismiss,
  })  : formFields = null,
        formKey = null,
        onSubmit = null,
        submitButtonText = 'SAVE',
        cancelButtonText = 'CANCEL',
        isLoading = false,
        super(key: key);

  /// Constructor for form mode
  const AppBottomSheet.form({
    Key? key,
    required this.title,
    required this.formFields,
    required this.formKey,
    required this.onSubmit,
    this.submitButtonText = 'SAVE',
    this.cancelButtonText = 'CANCEL',
    this.isLoading = false,
    this.isScrollControlled = true,
    this.onDismiss,
  })  : content = null,
        actions = null,
        super(key: key);

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();

  /// Static method to show the bottom sheet with proper configuration
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => child,
    );
  }
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  void _handleCancel() {
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
    Navigator.of(context).pop();
  }

  void _handleSubmit() {
    if (widget.formKey?.currentState?.validate() == true) {
      widget.onSubmit?.call();
    }
  }

  Widget _buildContent() {
    // Form mode
    if (widget.formFields != null) {
      return Form(
        key: widget.formKey!,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.formFields!.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: field,
                );
              }).toList(),
            ],
          ),
        ),
      );
    }

    // Regular content mode
    return widget.content ?? const SizedBox.shrink();
  }

  Widget? _buildActions() {
    // Form mode - build default form actions
    if (widget.formFields != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.isLoading ? null : _handleCancel,
            child: Text(widget.cancelButtonText),
          ),
          const SizedBox(width: 16),
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
      );
    }

    // Regular mode - use provided actions
    return widget.actions;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onDismiss != null) {
          widget.onDismiss!();
        }
        return true;
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        padding: EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          // Add padding to avoid keyboard overlap
          bottom: widget.isScrollControlled ? MediaQuery.of(context).viewInsets.bottom + 8 : 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title bar with drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Content - Make it flexible and scrollable
            Flexible(
              child: _buildContent(),
            ),
            // Actions footer
            if (_buildActions() != null) ...[
              const SizedBox(height: 8),
              _buildActions()!,
            ],
          ],
        ),
      ),
    );
  }
}
