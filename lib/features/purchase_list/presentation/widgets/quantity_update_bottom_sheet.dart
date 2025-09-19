import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.item.quantity;
    _priceController = TextEditingController(
      text: widget.item.unitPrice?.toStringAsFixed(2) ?? '',
    );
    // Add listener to update UI when price changes
    _priceController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
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
    // Parse the unit price from the text field
    final unitPrice = _priceController.text.isNotEmpty
        ? double.tryParse(_priceController.text)
        : null;

    final updatedItem = widget.item.copyWith(
      quantity: _currentQuantity,
      unitPrice: unitPrice,
    );
    widget.onUpdate(updatedItem);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Update Item',
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

          // Unit price input
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Unit Price (\$)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),

          const SizedBox(height: 24),

          // Unit info if available
          if (widget.item.unitPrice != null)
            Text(
              'Previous Unit Price: \$${widget.item.unitPrice}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),

          const SizedBox(height: 8),

          // Total calculation
          Builder(
            builder: (context) {
              final priceText = _priceController.text;
              final unitPrice = double.tryParse(priceText);

              if (unitPrice != null && unitPrice > 0) {
                final total = _currentQuantity * unitPrice;
                return Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                );
              } else {
                return Text(
                  'Enter unit price to see total',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                );
              }
            },
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
