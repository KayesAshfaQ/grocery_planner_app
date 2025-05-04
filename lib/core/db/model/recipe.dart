import 'package:floor/floor.dart';

/// Database model for recipes
@Entity(tableName: 'recipes')
class Recipe {
  /// Primary key identifier for the recipe
  @PrimaryKey(autoGenerate: true)
  final int? recipeId;

  /// Title of the recipe
  @ColumnInfo(name: 'title')
  final String title;

  /// Optional cooking instructions
  @ColumnInfo(name: 'instructions')
  final String? instructions;

  Recipe({
    this.recipeId,
    required this.title,
    this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipe_id': recipeId,
      'title': title,
      'instructions': instructions,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      recipeId: map['recipe_id'],
      title: map['title'],
      instructions: map['instructions'],
    );
  }
}
