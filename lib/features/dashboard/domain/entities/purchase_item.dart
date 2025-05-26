import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/catalog_item.dart';

/// Database model for items in a purchase list
class PurchaseItem extends Equatable {
  /// Primary key identifier for the purchase list item
  final int? id;

  /// Foreign key reference to the purchase list this item belongs to
  final int listId;

  /// Catalog-item of this purchase list item
  final CatalogItem? catalogItem;

  /// Optional custom name for the item (overrides catalog name
  final String? customName;

  /// Quantity of the item to purchase
  final double quantity;

  /// Optional unit price of the item
  final double? unitPrice;

  /// Optional total price (overrides quantity*unit_price if specified)
  final double? totalPrice;

  /// Optional note about this item
  final String? note;

  /// Whether the item has been purchased
  final bool isPurchased;

  /// Timestamp when the item was marked as purchased (nullable)
  final String? purchasedAt;

  const PurchaseItem({
    this.id,
    required this.listId,
    this.catalogItem,
    this.customName,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.note,
    required this.isPurchased,
    this.purchasedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': id,
      'list_id': listId,
      'catalog_id': catalogItem,
      'custom_name': customName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'note': note,
      'is_purchased': isPurchased ? 1 : 0,
      'purchased_at': purchasedAt,
    };
  }

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
      id: map['item_id'],
      listId: map['list_id'],
      catalogItem: map['catalog_id'],
      customName: map['custom_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      totalPrice: map['total_price'],
      note: map['note'],
      isPurchased: map['is_purchased'] == 1,
      purchasedAt: map['purchased_at'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        catalogItem,
        customName,
        quantity,
        unitPrice,
        totalPrice,
        note,
        isPurchased,
        purchasedAt,
      ];
}
