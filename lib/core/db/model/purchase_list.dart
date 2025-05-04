class PurchaseList {
  final int? listId;
  final String name;
  final double? budget;
  final String? note;
  final DateTime createdAt;

  PurchaseList({
    this.listId,
    required this.name,
    this.budget,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'list_id': listId,
      'name': name,
      'budget': budget,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PurchaseList.fromMap(Map<String, dynamic> map) {
    return PurchaseList(
      listId: map['list_id'],
      name: map['name'],
      budget: map['budget'],
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
