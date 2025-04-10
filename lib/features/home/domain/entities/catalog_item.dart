import 'package:equatable/equatable.dart';

/// Represents a pre-registered grocery item in the catalog
///
/// [CatalogItem] is used to provide a database of common grocery items
/// that users can select from when adding items to their shopping list.
class CatalogItem extends Equatable {
  /// Unique identifier for the catalog item
  final String id;

  /// Name of the grocery item
  final String name;

  /// Common units of measurement for this item
  final List<String> availableUnits;

  /// Default unit of measurement for this item
  final String defaultUnit;

  /// Category of the item (e.g., dairy, produce, meat)
  final String category;

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
    required this.category,
    this.averagePrice,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        availableUnits,
        category,
        averagePrice,
        imageUrl,
      ];
}
