import 'package:equatable/equatable.dart';

/// Represents a price history record for a grocery item
///
/// [PriceHistory] tracks the price changes of grocery items over time
/// to support price fluctuation analyses and graphs.
class PriceHistory extends Equatable {
  /// Unique identifier for this price history record
  final String id;

  /// The ID of the grocery item this price history belongs to
  final String itemId;

  /// The name of the grocery item
  final String itemName;

  /// The unit used for this price (e.g., kg, pcs, l)
  final String unit;

  /// The recorded price at this point in time
  final double price;

  /// When this price was recorded
  final DateTime recordedAt;

  /// Optional store/location where this price was observed
  final String? location;

  /// Creates a new price history record
  const PriceHistory({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.unit,
    required this.price,
    required this.recordedAt,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        itemId,
        itemName,
        unit,
        price,
        recordedAt,
        location,
      ];
}
