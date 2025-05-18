import 'package:equatable/equatable.dart';

/// Represents a pre-registered grocery item in the catalog
///
/// [CatalogItem] is used to provide a database of common grocery items
/// that users can select from when adding items to their shopping list.
class CatalogItem extends Equatable {
  /// Unique identifier for the catalog item
  final int id;

  /// Name of the grocery item
  final String name;

  /// Common units of measurement for this item
  final List<String> availableUnits;

  /// Default unit of measurement for this item
  final String defaultUnit;

  /// Id of the category
  final int categoryId;

  /// Average market price (if known)
  final double? averagePrice;

  /// A URI pointing to an image of the item, if available
  final String? imageUrl;

  /// Creates a new catalog item
  const CatalogItem({
    required this.id,
    required this.name,
    required this.availableUnits,
    required this.defaultUnit,
    required this.categoryId,
    this.averagePrice,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        availableUnits,
        categoryId,
        averagePrice,
        imageUrl,
      ];
}
