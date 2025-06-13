import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_price_history.dart';

/// Database model for purchase price history records
@Entity(tableName: 'purchase_price_history')
class PurchasePriceHistoryModel {
  /// Primary key identifier for the price history record
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Foreign key reference to the purchase list item this price is associated with
  @ColumnInfo(name: 'item_id')
  final int? itemId;

  /// The actual price paid or corrected
  @ColumnInfo(name: 'price')
  final double price;

  /// Timestamp when this price was recorded
  @ColumnInfo(name: 'recorded_at')
  final String recordedAt;

  PurchasePriceHistoryModel({
    this.id,
    required this.itemId,
    required this.price,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'history_id': id,
      'item_id': itemId,
      'price': price,
      'recorded_at': recordedAt,
    };
  }

  factory PurchasePriceHistoryModel.fromMap(Map<String, dynamic> map) {
    return PurchasePriceHistoryModel(
      id: map['history_id'],
      itemId: map['item_id'],
      price: map['price'],
      recordedAt: map['recorded_at'],
    );
  }

  /// Converts the model to a domain entity
  ///
  /// This method is used to convert the database model into a domain entity
  /// that can be used in the application logic.
  PurchasePriceHistory toEntity() {
    return PurchasePriceHistory(
      id: id,
      itemId: itemId,
      price: price,
      recordedAt: recordedAt,
    );
  }

  /// Creates a model from a domain entity
  ///
  /// This method is used to convert a domain entity into a database model
  /// that can be stored in the local database.
  factory PurchasePriceHistoryModel.fromEntity(PurchasePriceHistory purchasePriceHistory) {
    return PurchasePriceHistoryModel(
      id: purchasePriceHistory.id,
      itemId: purchasePriceHistory.itemId,
      price: purchasePriceHistory.price,
      recordedAt: purchasePriceHistory.recordedAt,
    );
  }
}
