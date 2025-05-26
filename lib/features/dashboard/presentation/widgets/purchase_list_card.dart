import 'package:flutter/material.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_list.dart';

/// Widget for displaying a purchase list item in a card format
class PurchaseListCard extends StatelessWidget {
  /// The purchase list item to display
  final PurchaseList purchaseList;

  /// Callback for marking the item as purchased
  final VoidCallback? onMarkPurchased;

  /// Callback for editing the item
  final VoidCallback? onEdit;

  /// Callback for deleting the item
  final VoidCallback? onDelete;

  /// Creates a new purchase list item card
  const PurchaseListCard({
    Key? key,
    required this.purchaseList,
    this.onMarkPurchased,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final currencyFormat = NumberFormat.currency(symbol: '\$');
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
                        purchaseList.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          decoration: purchaseList.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final categories = purchaseList.purchaseItems
                              .map((item) => item.catalogItem?.category?.name)
                              .where((name) => name != null)
                              .toSet()
                              .join(', ');

                          return Text(
                            'Category: ${categories.isNotEmpty ? categories : 'Unknown'}',
                            style: theme.textTheme.bodyMedium,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: purchaseList.isCompleted
                        ? Colors.green.withValues(alpha: 0.2)
                        : theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    purchaseList.isCompleted ? 'Purchased' : 'To Buy',
                    style: TextStyle(
                      color: purchaseList.isCompleted ? Colors.green.shade800 : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${purchaseList.purchaseItems.length} ${purchaseList.purchaseItems.length == 1 ? 'item' : 'items'}',
              style: theme.textTheme.bodyLarge,
            ),
            /* Row(
              children: [
                Text(
                  '${purchaseList.purchaseItems.length} ${purchaseList.purchaseItems.length == 1 ? 'item' : 'items'}',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  purchaseList.isCompleted ? '${currencyFormat.format(purchaseList.purchasedPrice)} per ${purchaseList.unit}' : '${currencyFormat.format(purchaseList.unitPrice)} per ${purchaseList.unit}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ), */
            if (purchaseList.note != null && purchaseList.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${purchaseList.note}',
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
