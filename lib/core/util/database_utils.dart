import 'package:flutter/material.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/core/db/app_database.dart';

/// Utility class for database operations during development
class DatabaseUtils {
  /// Clear all data and reset database schema
  /// WARNING: This will delete all user data! Use only during development.
  static Future<void> resetDatabase() async {
    try {
      final database = sl<AppDatabase>();

      // Delete all data from all tables
      await database.database.execute('DELETE FROM purchase_lists');
      await database.database.execute('DELETE FROM purchase_list_items');
      await database.database.execute('DELETE FROM purchase_price_history');
      await database.database.execute('DELETE FROM categories');
      await database.database.execute('DELETE FROM catalog_items');
      await database.database.execute('DELETE FROM price_history');
      await database.database.execute('DELETE FROM purchase_schedules');
      await database.database.execute('DELETE FROM purchase_locations');
      await database.database.execute('DELETE FROM recipes');
      await database.database.execute('DELETE FROM recipe_ingredients');

      // Reset auto-increment counters
      await database.database.execute('DELETE FROM sqlite_sequence');

      debugPrint('✅ Database reset successfully');
    } catch (e) {
      debugPrint('❌ Database reset failed: $e');
    }
  }

  /// Show a confirmation dialog for database reset
  static Future<void> showResetConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text(
          'This will delete all data and reset the database. '
          'This action cannot be undone. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await resetDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database reset successfully')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
