import 'package:equatable/equatable.dart';

/// Database model for items in a purchase list
class PurchaseItem extends Equatable {
  /// Primary key identifier for the purchase list item
  final int? id;

  /// Foreign key reference to the purchase list this item belongs to
  final int listId;

  /// Optional foreign key reference to the catalog item this purchase is based on
  final int? catalogId;

  /// Optional custom name for the item (overrides catalog name
  final String? customName;

  /// Quantity of the item to purchase
  final double quantity;

  /// Optional unit price of the item
  final double? unitPrice;

  /// Optional note about this item
  final String? note;

  /// Whether the item has been purchased
  final bool isPurchased;

  /// Timestamp when the item was marked as purchased (nullable)
  final String? purchasedAt;

  const PurchaseItem({
    this.id,
    required this.listId,
    this.catalogId,
    this.customName,
    required this.quantity,
    this.unitPrice,
    this.note,
    required this.isPurchased,
    this.purchasedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': id,
      'list_id': listId,
      'catalog_id': catalogId,
      'custom_name': customName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'note': note,
      'is_purchased': isPurchased ? 1 : 0,
      'purchased_at': purchasedAt,
    };
  }

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
      id: map['item_id'],
      listId: map['list_id'],
      catalogId: map['catalog_id'],
      customName: map['custom_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      note: map['note'],
      isPurchased: map['is_purchased'] == 1,
      purchasedAt: map['purchased_at'],
    );
  }

  /// Creates a copy of this PurchaseItem with the given fields replaced with new values
  PurchaseItem copyWith({
    int? id,
    int? listId,
    int? catalogId,
    String? customName,
    double? quantity,
    double? unitPrice,
    String? note,
    bool? isPurchased,
    String? purchasedAt,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      catalogId: catalogId ?? this.catalogId,
      customName: customName ?? this.customName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      note: note ?? this.note,
      isPurchased: isPurchased ?? this.isPurchased,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        catalogId,
        customName,
        quantity,
        unitPrice,
        note,
        isPurchased,
        purchasedAt,
      ];
}
