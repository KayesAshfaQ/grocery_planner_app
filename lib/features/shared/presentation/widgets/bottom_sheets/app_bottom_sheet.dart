import 'package:flutter/material.dart';

/// Base bottom sheet with consistent styling and layout
///
/// This widget provides a standardized bottom sheet design for the app,
/// handling padding, title styling, and basic layout structure.
class AppBottomSheet extends StatelessWidget {
  /// Title of the bottom sheet
  final String title;

  /// Main content area of the bottom sheet
  final Widget content;

  /// Optional footer actions (typically buttons)
  /// If null, no footer will be displayed
  final Widget? actions;

  /// Controls if bottom sheet should size to fit content
  final bool isScrollControlled;

  /// Callback when user attempts to dismiss the sheet
  final VoidCallback? onDismiss;

  const AppBottomSheet({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.isScrollControlled = true,
    this.onDismiss,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onDismiss != null) {
          onDismiss!();
        }
        return true;
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          // Add padding to avoid keyboard overlap
          bottom: isScrollControlled ? MediaQuery.of(context).viewInsets.bottom + 16 : 16,
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
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Content
            content,
            // Actions footer
            if (actions != null) ...[
              const SizedBox(height: 24),
              actions!,
            ],
          ],
        ),
      ),
    );
  }
}