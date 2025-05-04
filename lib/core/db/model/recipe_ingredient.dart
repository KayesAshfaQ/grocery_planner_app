class RecipeIngredient {
  final int? id;
  final int recipeId;
  final int catalogId;
  final double? quantity;
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
