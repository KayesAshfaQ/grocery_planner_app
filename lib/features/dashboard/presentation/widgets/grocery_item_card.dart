import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:grocery_planner_app/features/dashboard/domain/entities/grocery_item.dart';

/// Widget for displaying a grocery item in a card format
class GroceryItemCard extends StatelessWidget {
  /// The grocery item to display
  final GroceryItem groceryItem;

  /// Callback for marking the item as purchased
  final VoidCallback? onMarkPurchased;

  /// Callback for editing the item
  final VoidCallback? onEdit;

  /// Callback for deleting the item
  final VoidCallback? onDelete;

  /// Creates a new grocery item card
  const GroceryItemCard({
    Key? key,
    required this.groceryItem,
    this.onMarkPurchased,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groceryItem.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          decoration: groceryItem.isPurchased
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${groceryItem.categoryId}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: groceryItem.isPurchased
                        ? Colors.green.withOpacity(0.2)
                        : theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    groceryItem.isPurchased ? 'Purchased' : 'To Buy',
                    style: TextStyle(
                      color: groceryItem.isPurchased
                          ? Colors.green.shade800
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${groceryItem.quantity} ${groceryItem.unit}',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  groceryItem.isPurchased && groceryItem.purchasedPrice != null
                      ? '${currencyFormat.format(groceryItem.purchasedPrice)} per ${groceryItem.unit}'
                      : '${currencyFormat.format(groceryItem.unitPrice)} per ${groceryItem.unit}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (groceryItem.note != null && groceryItem.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${groceryItem.note}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    onPressed: onDelete,
                    tooltip: 'Delete',
                  ),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                const Spacer(),
                if (onMarkPurchased != null)
                  TextButton.icon(
                    onPressed: onMarkPurchased,
                    icon: const Icon(Icons.check),
                    label: const Text('MARK PURCHASED'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
