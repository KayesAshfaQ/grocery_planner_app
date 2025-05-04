class PurchaseListItem {
  final int? itemId;
  final int listId;
  final int? catalogId;
  final String? customName;
  final double quantity;
  final double? unitPrice;
  final double? totalPrice;
  final String? note;
  final bool isPurchased;
  final DateTime? purchasedAt;

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
      'purchased_at': purchasedAt?.toIso8601String(),
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
      purchasedAt: map['purchased_at'] != null ? DateTime.parse(map['purchased_at']) : null,
    );
  }
}
