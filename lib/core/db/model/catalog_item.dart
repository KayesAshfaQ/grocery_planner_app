import 'package:floor/floor.dart';

/// Database model for catalog items
@Entity(tableName: 'catalog_items')
class CatalogItem {
  /// Primary key identifier for the catalog item
  @PrimaryKey(autoGenerate: true)
  final int? catalogId;

  /// Name of the catalog item
  @ColumnInfo(name: 'name')
  final String name;

  /// Default unit of measurement for this item (e.g. 'kg', 'pcs', 'litre')
  @ColumnInfo(name: 'default_unit')
  final String defaultUnit;

  /// Barcode of the item (nullable)
  @ColumnInfo(name: 'barcode')
  final String? barcode;

  /// Reference to the category ID this item belongs to
  @ColumnInfo(name: 'category_id')
  final int? categoryId;

  CatalogItem({
    this.catalogId,
    required this.name,
    required this.defaultUnit,
    this.barcode,
    this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'catalog_id': catalogId,
      'name': name,
      'default_unit': defaultUnit,
      'barcode': barcode,
      'category_id': categoryId,
    };
  }

  factory CatalogItem.fromMap(Map<String, dynamic> map) {
    return CatalogItem(
      catalogId: map['catalog_id'],
      name: map['name'],
      defaultUnit: map['default_unit'],
      barcode: map['barcode'],
      categoryId: map['category_id'],
    );
  }
}
