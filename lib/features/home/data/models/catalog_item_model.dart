import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/home/domain/entities/catalog_item.dart';

/// Database model for catalog items
@Entity(tableName: 'catalog_items')
class CatalogItemModel {
  /// Primary key
  @primaryKey
  final String id;

  /// Name of the grocery item
  final String name;

  /// Available units as comma-separated values (CSV)
  final String availableUnitsCSV;

  /// Default unit of measurement for this item
  final String defaultUnit;

  /// Category of the item
  final String category;

  /// Average market price (nullable)
  final double? averagePrice;

  /// URL to an image of the item (nullable)
  final String? imageUrl;

  /// Creates a new catalog item model
  CatalogItemModel({
    required this.id,
    required this.name,
    required this.availableUnitsCSV,
    required this.defaultUnit,
    required this.category,
    this.averagePrice,
    this.imageUrl,
  });

  /// Converts this model to a domain entity
  CatalogItem toEntity() {
    return CatalogItem(
      id: id,
      name: name,
      availableUnits: availableUnitsCSV.split(','),
      defaultUnit: defaultUnit,
      category: category,
      averagePrice: averagePrice,
      imageUrl: imageUrl,
    );
  }

  /// Creates a model from a domain entity
  factory CatalogItemModel.fromEntity(CatalogItem entity) {
    return CatalogItemModel(
      id: entity.id,
      name: entity.name,
      availableUnitsCSV: entity.availableUnits.join(','),
      defaultUnit: entity.defaultUnit,
      category: entity.category,
      averagePrice: entity.averagePrice,
      imageUrl: entity.imageUrl,
    );
  }
}
