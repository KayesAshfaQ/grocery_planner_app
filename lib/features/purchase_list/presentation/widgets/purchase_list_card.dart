import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';

/// Widget for displaying a purchase list item in a card format
class PurchaseListCard extends StatelessWidget {
  /// The purchase list item to display
  final PurchaseList purchaseList;

  /// Optional callback for when the item is pressed
  final VoidCallback? onPressed;

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
    this.onPressed,
    this.onMarkPurchased,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Card(
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
                    child: Text(
                      purchaseList.name ?? 'Unnamed List',
                      style: theme.textTheme.titleLarge?.copyWith(
                        decoration: purchaseList.isCompleted == true
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: purchaseList.isCompleted == true
                          ? Colors.green.withValues(alpha: 0.2)
                          : theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      purchaseList.isCompleted == true ? 'Purchased' : 'To Buy',
                      style: TextStyle(
                        color: purchaseList.isCompleted == true
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
                  Builder(
                    builder: (context) {
                      final itemCount = purchaseList.purchaseItems.length;
                      final purchasedCount = purchaseList.purchaseItems
                          .where((item) => item.isPurchased)
                          .length;

                      String statusText;
                      if (purchaseList.isCompleted == true) {
                        statusText = 'All items purchased';
                      } else if (purchasedCount > 0) {
                        statusText =
                            '$purchasedCount out of $itemCount ${purchaseList.purchaseItems.length == 1 ? 'item' : 'items'} purchased';
                      } else {
                        statusText = 'Ready to shop';
                      }

                      return Text(
                        statusText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: purchaseList.isCompleted == true
                              ? Colors.green.shade600
                              : purchasedCount > 0
                                  ? Colors.orange.shade600
                                  : theme.textTheme.bodyMedium?.color,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Builder(builder: (context) {
                    double totalPurchasedPrice = 0.0;
                    double totalQty = 0.0;
                    double purchasedQty = 0.0;

                    for (var item in purchaseList.purchaseItems) {
                      // Calculate total quantity
                      totalQty += item.quantity;

                      // Calculate purchased quantity and price
                      if (item.isPurchased) {
                        purchasedQty += item.quantity;

                        // Only add to price if item has a unit price
                        if (item.unitPrice != null) {
                          totalPurchasedPrice +=
                              item.unitPrice! * item.quantity;
                        }
                      }
                    }

                    // Format quantity display
                    String quantityText =
                        'Qty: ${purchasedQty.toInt()}/${totalQty.toInt()}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          quantityText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Only show price if there are purchased items with prices
                        if (purchasedQty > 0 && totalPurchasedPrice > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            currencyFormat.format(totalPurchasedPrice),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
              if (purchaseList.note != null &&
                  purchaseList.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Note: ${purchaseList.note}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
