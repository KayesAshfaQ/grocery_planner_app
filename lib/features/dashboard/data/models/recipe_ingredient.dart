import 'package:floor/floor.dart';

/// Database model for recipe ingredients
@Entity(tableName: 'recipe_ingredients')
class RecipeIngredient {
  /// Primary key identifier for the recipe ingredient
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Foreign key reference to the recipe this ingredient belongs to
  @ColumnInfo(name: 'recipe_id')
  final int recipeId;

  /// Foreign key reference to the catalog item for this ingredient
  @ColumnInfo(name: 'catalog_id')
  final int catalogId;

  /// Optional quantity needed for the recipe
  @ColumnInfo(name: 'quantity')
  final double? quantity;

  /// Optional unit of measurement (e.g., 'kg', 'pcs', 'teaspoon')
  @ColumnInfo(name: 'unit')
  final String? unit;

  RecipeIngredient({
    this.id,
    required this.recipeId,
    required this.catalogId,
    this.quantity,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'catalog_id': catalogId,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      id: map['id'],
      recipeId: map['recipe_id'],
      catalogId: map['catalog_id'],
      quantity: map['quantity'],
      unit: map['unit'],
    );
  }
}
