import 'package:floor/floor.dart';

/// Database model for categories of grocery items
@Entity(tableName: 'categories')
class Category {
  /// Primary key identifier for the category
  @PrimaryKey(autoGenerate: true)
  final int? categoryId;

  /// Name of the category
  @ColumnInfo(name: 'name')
  final String name;

  /// Optional description of the category
  @ColumnInfo(name: 'description')
  final String? description;

  Category({
    this.categoryId,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'description': description,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['category_id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
