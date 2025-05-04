class PriceHistory {
  final int? historyId;
  final int catalogId;
  final double price;
  final DateTime recordedAt;

  PriceHistory({
    this.historyId,
    required this.catalogId,
    required this.price,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'history_id': historyId,
      'catalog_id': catalogId,
      'price': price,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory PriceHistory.fromMap(Map<String, dynamic> map) {
    return PriceHistory(
      historyId: map['history_id'],
      catalogId: map['catalog_id'],
      price: map['price'],
      recordedAt: DateTime.parse(map['recorded_at']),
    );
  }
}
