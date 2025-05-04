class PurchasePriceHistory {
  final int? historyId;
  final int itemId;
  final double price;
  final DateTime recordedAt;

  PurchasePriceHistory({
    this.historyId,
    required this.itemId,
    required this.price,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'history_id': historyId,
      'item_id': itemId,
      'price': price,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory PurchasePriceHistory.fromMap(Map<String, dynamic> map) {
    return PurchasePriceHistory(
      historyId: map['history_id'],
      itemId: map['item_id'],
      price: map['price'],
      recordedAt: DateTime.parse(map['recorded_at']),
    );
  }
}
