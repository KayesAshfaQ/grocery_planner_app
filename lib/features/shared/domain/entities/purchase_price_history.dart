import 'package:equatable/equatable.dart';

/// Represents purchase price history of a purchase item in the purchase list
///
/// [PurchasePriceHistory] is used to provide a record of prices paid for items
/// in the purchase list. It allows tracking of price changes over time,
/// enabling users to see historical prices and make informed decisions about
/// future purchases. This is particularly useful for items that may have
/// fluctuating prices or for users who want to track their spending habits.
class PurchasePriceHistory extends Equatable {
  /// Unique identifier for the purchase price history record
  final int? id;

  /// Foreign key reference to the purchase list item this price is associated with
  final int? itemId;

  /// The actual price paid or corrected
  final double price;

  /// Timestamp when this price was recorded
  final String recordedAt;

  /// Creates a new purchase price history record
  const PurchasePriceHistory({
    this.id,
    this.itemId,
    required this.price,
    required this.recordedAt,
  });

  @override
  List<Object?> get props => [
        id,
        itemId,
        price,
        recordedAt,
      ];
}
