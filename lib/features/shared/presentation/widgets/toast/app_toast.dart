import 'package:flutter/material.dart';

/// Utility class for showing consistent toast messages throughout the app
class AppToast {
  /// Shows a success message with green background
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustom(
      context,
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  /// Shows an error message with red background
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showCustom(
      context,
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
    );
  }

  /// Shows an info message with blue background
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustom(
      context,
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
    );
  }

  /// Shows a warning message with orange background
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustom(
      context,
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
    );
  }

  /// Shows a custom snackbar with specified colors and icon
  static void showCustom(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    bool showAction = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.grey[800],
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: showAction
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: textColor ?? Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              )
            : null,
      ),
    );
  }
}
