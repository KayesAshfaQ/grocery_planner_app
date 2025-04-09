import 'package:floor/floor.dart';

/// Model representing price fluctuation statistics for an item
@Entity()
class PriceFluctuationStatisticsModel {
  /// Primary key
  @primaryKey
  final String id;

  /// The minimum price for an item
  final double minPrice;

  /// The maximum price for an item
  final double maxPrice;

  /// The average price for an item
  final double avgPrice;

  /// The total number of records
  final double? recordCount;

  /// Creates a new category spending model
  PriceFluctuationStatisticsModel({
    required this.id,
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.recordCount,
  });
}
