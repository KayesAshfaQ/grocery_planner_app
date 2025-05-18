import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/category.dart';

/// Database model for category items
@Entity(tableName: 'category')
class CategoryModel {
  /// Primary key
  @primaryKey
  final int id;

  /// Name of the grocery item
  final String name;

  /// Description of the category item
  final String? description;

  /// A URI pointing to an image of the item, if available
  final String? imageUrl;


  /// Creates a new catalog item model
  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  /// Converts this model to a domain entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  /// Creates a model from a domain entity
  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      id: entity.id!,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
    );
  }
}
