import 'package:equatable/equatable.dart';

/// Represents a pre-registered grocery item in the catalog
///
/// [Category] is used to provide a database of common grocery items
/// that users can select from when adding items to their shopping list.
class Category extends Equatable {
  /// Unique identifier for the catalog item
  final int? id;

  /// Name of the category item
  final String? name;

  /// Description of the category item
  final String? description;

  /// A URI pointing to an image of the item, if available
  final String? imageUri;

  /// Creates a new category
  const Category({
    this.id,
    this.name,
    this.description,
    this.imageUri,
  });

  /// Creates a copy of this category with the given fields replaced with new values
  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUri,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUri: imageUri ?? this.imageUri,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUri,
      ];
}
