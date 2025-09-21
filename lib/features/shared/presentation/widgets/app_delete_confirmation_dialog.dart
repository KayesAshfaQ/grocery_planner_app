import 'package:flutter/material.dart';

/// Reusable delete confirmation dialog for any entity
class AppDeleteConfirmationDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String deleteText = 'Delete',
    Color deleteColor = Colors.red,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: deleteColor,
              ),
              child: Text(deleteText),
            ),
          ],
        );
      },
    );
  }
}
