import 'package:floor/floor.dart';

/// Model representing spending totals by category
@Entity()
class CategorySpendingModel {
  /// Primary key
  @primaryKey
  final String id;

  /// The category name
  final String category;

  /// The total amount spent in this category
  final double value;

  /// Creates a new category spending model
  CategorySpendingModel({
    required this.id,
    required this.category,
    required this.value,
  });
}
