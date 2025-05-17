import 'package:floor/floor.dart';

/// Database model for items in a purchase list
@Entity(tableName: 'purchase_list_items')
class PurchaseListItem {
  /// Primary key identifier for the purchase list item
  @PrimaryKey(autoGenerate: true)
  final int? itemId;

  /// Foreign key reference to the purchase list this item belongs to
  @ColumnInfo(name: 'list_id')
  final int listId;

  /// Optional foreign key reference to the catalog item this purchase is based on
  @ColumnInfo(name: 'catalog_id')
  final int? catalogId;

  /// Optional custom name for the item (overrides catalog name)
  @ColumnInfo(name: 'custom_name')
  final String? customName;

  /// Quantity of the item to purchase
  @ColumnInfo(name: 'quantity')
  final double quantity;

  /// Optional unit price of the item
  @ColumnInfo(name: 'unit_price')
  final double? unitPrice;

  /// Optional total price (overrides quantity*unit_price if specified)
  @ColumnInfo(name: 'total_price')
  final double? totalPrice;

  /// Optional note about this item
  @ColumnInfo(name: 'note')
  final String? note;

  /// Whether the item has been purchased
  @ColumnInfo(name: 'is_purchased')
  final bool isPurchased;

  /// Timestamp when the item was marked as purchased (nullable)
  @ColumnInfo(name: 'purchased_at')
  final String? purchasedAt;

  PurchaseListItem({
    this.itemId,
    required this.listId,
    this.catalogId,
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
      'item_id': itemId,
      'list_id': listId,
      'catalog_id': catalogId,
      'custom_name': customName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'note': note,
      'is_purchased': isPurchased ? 1 : 0,
      'purchased_at': purchasedAt,
    };
  }

  factory PurchaseListItem.fromMap(Map<String, dynamic> map) {
    return PurchaseListItem(
      itemId: map['item_id'],
      listId: map['list_id'],
      catalogId: map['catalog_id'],
      customName: map['custom_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      totalPrice: map['total_price'],
      note: map['note'],
      isPurchased: map['is_purchased'] == 1,
      purchasedAt: map['purchased_at'] != null ? map['purchased_at'] : null,
    );
  }
}
