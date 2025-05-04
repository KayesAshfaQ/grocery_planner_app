class Recipe {
  final int? recipeId;
  final String title;
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
