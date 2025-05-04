class CatalogItem {
  final int? catalogId;
  final String name;
  final String defaultUnit;
  final String? barcode;
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
