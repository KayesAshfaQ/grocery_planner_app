class Category {
  final int? categoryId;
  final String name;
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
