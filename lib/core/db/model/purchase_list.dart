import 'package:floor/floor.dart';

/// Database model for purchase lists
@Entity(tableName: 'purchase_lists')
class PurchaseList {
  /// Primary key identifier for the purchase list
  @PrimaryKey(autoGenerate: true)
  final int? listId;

  /// Name of the purchase list
  @ColumnInfo(name: 'name')
  final String name;

  /// Optional budget for this purchase list
  @ColumnInfo(name: 'budget')
  final double? budget;

  /// Optional note about this purchase list
  @ColumnInfo(name: 'note')
  final String? note;

  /// Timestamp when this list was created
  @ColumnInfo(name: 'created_at')
  final String createdAt;

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
      'created_at': createdAt,
    };
  }

  factory PurchaseList.fromMap(Map<String, dynamic> map) {
    return PurchaseList(
      listId: map['list_id'],
      name: map['name'],
      budget: map['budget'],
      note: map['note'],
      createdAt: map['created_at'],
    );
  }
}
