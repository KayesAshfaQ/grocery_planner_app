import 'package:floor/floor.dart';

/// Database model for purchase price history records
@Entity(tableName: 'purchase_price_history')
class PurchasePriceHistory {
  /// Primary key identifier for the price history record
  @PrimaryKey(autoGenerate: true)
  final int? historyId;

  /// Foreign key reference to the purchase list item this price is associated with
  @ColumnInfo(name: 'item_id')
  final int itemId;

  /// The actual price paid or corrected
  @ColumnInfo(name: 'price')
  final double price;

  /// Timestamp when this price was recorded
  @ColumnInfo(name: 'recorded_at')
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
