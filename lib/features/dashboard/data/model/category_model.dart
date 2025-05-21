import 'package:floor/floor.dart';

/// Database model for categories of grocery items
@Entity(tableName: 'categories')
class CategoryModel {
  /// Primary key identifier for the category
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Name of the category
  @ColumnInfo(name: 'name')
  final String name;

  /// Optional description of the category
  @ColumnInfo(name: 'description')
  final String? description;

  /// A URI pointing to an image of the item, if available
  @ColumnInfo(name: 'image_uri')
  final String? imageUri;

  CategoryModel({
    this.id,
    required this.name,
    this.description,
    this.imageUri,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': id,
      'name': name,
      'description': description,
      'image_uri': imageUri,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['category_id'],
      name: map['name'],
      description: map['description'],
      imageUri: map['image_uri'],
    );
  }
}
