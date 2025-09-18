import 'package:flutter/material.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';

/// Bottom sheet for updating purchase item quantity
class QuantityUpdateBottomSheet extends StatefulWidget {
  final PurchaseItem item;
  final Function(PurchaseItem) onUpdate;

  const QuantityUpdateBottomSheet({
    Key? key,
    required this.item,
    required this.onUpdate,
  }) : super(key: key);

  /// Shows the quantity update bottom sheet
  static Future<void> show(
    BuildContext context, {
    required PurchaseItem item,
    required Function(PurchaseItem) onUpdate,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: QuantityUpdateBottomSheet(
        item: item,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<QuantityUpdateBottomSheet> createState() =>
      _QuantityUpdateBottomSheetState();
}

class _QuantityUpdateBottomSheetState extends State<QuantityUpdateBottomSheet> {
  late double _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.item.quantity;
  }

  void _increaseQuantity() {
    setState(() {
      _currentQuantity += 1;
    });
  }

  void _decreaseQuantity() {
    if (_currentQuantity > 1) {
      setState(() {
        _currentQuantity -= 1;
      });
    }
  }

  void _handleSave() {
    final updatedItem = widget.item.copyWith(quantity: _currentQuantity);
    widget.onUpdate(updatedItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Update Quantity',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Item info
          Text(
            widget.item.customName ?? 'Item #${widget.item.catalogId ?? 'N/A'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Current: ${widget.item.quantity} pcs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // Quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrease button
              IconButton(
                onPressed: _currentQuantity > 1 ? _decreaseQuantity : null,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 48,
                color: _currentQuantity > 1
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),

              const SizedBox(width: 24),

              // Current quantity display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentQuantity.toInt().toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              const SizedBox(width: 24),

              // Increase button
              IconButton(
                onPressed: _increaseQuantity,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 48,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Unit info if available
          if (widget.item.unitPrice != null)
            Text(
              'Unit Price: \$${widget.item.unitPrice}',
              style: Theme.of(context).textTheme.bodySmall,
            ),

          const SizedBox(height: 8),

          // Total calculation
          if (widget.item.unitPrice != null)
            Text(
              'Total: \$${(_currentQuantity * widget.item.unitPrice!).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
        ],
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _handleSave,
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
