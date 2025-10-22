import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';

/// Represents a pre-registered grocery item in the catalog
///
/// [CatalogItem] is used to provide a database of common grocery items
/// that users can select from when adding items to their shopping list.
class CatalogItem extends Equatable {
  CatalogItem copyWith({
    int? id,
    String? name,
    String? defaultUnit,
    String? barcode,
    Category? category,
    String? imageUri,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      imageUri: imageUri ?? this.imageUri,
    );
  }

  /// Unique identifier for the catalog item
  final int? id;

  /// Name of the grocery item
  final String name;

  /// Default unit of measurement for this item
  final String? defaultUnit;

  /// Barcode of the item (nullable)
  final String? barcode;

  /// Category of the item
  final Category? category;

  /// URI to an image of the item (nullable)
  final String? imageUri;

  /// Creates a new catalog item
  const CatalogItem({
    this.id,
    required this.name,
    this.defaultUnit,
    this.barcode,
    this.category,
    this.imageUri,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        defaultUnit,
        barcode,
        category,
        imageUri,
      ];
}
