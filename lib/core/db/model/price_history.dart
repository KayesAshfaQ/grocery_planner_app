import 'package:floor/floor.dart';

/// Database model for historical pricing data
@Entity(tableName: 'price_history')
class PriceHistory {
  /// Primary key identifier for the price history record
  @PrimaryKey(autoGenerate: true)
  final int? historyId;

  /// Foreign key reference to the catalog item this price is associated with
  @ColumnInfo(name: 'catalog_id')
  final int catalogId;

  /// The recorded price value
  @ColumnInfo(name: 'price')
  final double price;

  /// Timestamp when this price was recorded
  @ColumnInfo(name: 'recorded_at')
  final String recordedAt;

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
      'recorded_at': recordedAt,
    };
  }

  factory PriceHistory.fromMap(Map<String, dynamic> map) {
    return PriceHistory(
      historyId: map['history_id'],
      catalogId: map['catalog_id'],
      price: map['price'],
      recordedAt: map['recorded_at'],
    );
  }
}
