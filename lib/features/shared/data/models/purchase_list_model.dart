import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';

/// Database model for purchase lists
@Entity(tableName: 'purchase_lists')
class PurchaseListModel {
  /// Primary key identifier for the purchase list
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Name of the purchase list
  @ColumnInfo(name: 'name')
  final String? name;

  /// Indicates whether this purchase list is completed
  @ColumnInfo(name: 'is_completed')
  final bool? isCompleted;

  /// Optional budget for this purchase list
  @ColumnInfo(name: 'budget')
  final double? budget;

  /// Optional currency symbol for the budget
  @ColumnInfo(name: 'currency_symbol')
  final String? currencySymbol;

  /// Optional note about this purchase list
  @ColumnInfo(name: 'note')
  final String? note;

  /// Timestamp when this list was created
  @ColumnInfo(name: 'created_at')
  final String? createdAt;

  PurchaseListModel({
    this.id,
    this.name,
    this.isCompleted = false,
    this.budget,
    this.currencySymbol,
    this.note,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'list_id': id,
      'name': name,
      'is_completed': isCompleted,
      'budget': budget,
      'currency_symbol': currencySymbol,
      'note': note,
      'created_at': createdAt,
    };
  }

  factory PurchaseListModel.fromMap(Map<String, dynamic> map) {
    return PurchaseListModel(
      id: map['list_id'],
      name: map['name'],
      isCompleted: map['is_completed'] ?? false,
      budget: map['budget'],
      currencySymbol: map['currency_symbol'],
      note: map['note'],
      createdAt: map['created_at'],
    );
  }

  /// Converts the model to a domain entity
  ///
  /// This method is used to convert the database model into a domain entity
  /// that can be used in the application logic.
  PurchaseList toEntity() {
    return PurchaseList(
      id: id,
      name: name,
      isCompleted: isCompleted,
      budget: budget,
      currencySymbol: currencySymbol,
      note: note,
      createdAt: createdAt,
      purchaseItems: [],
    );
  }

  /// Creates a model from a domain entity
  ///
  /// This method is used to convert a domain entity into a database model
  /// that can be stored in the local database.
  factory PurchaseListModel.fromEntity(PurchaseList purchaseList) {
    return PurchaseListModel(
      id: purchaseList.id,
      name: purchaseList.name,
      isCompleted: purchaseList.isCompleted,
      budget: purchaseList.budget,
      note: purchaseList.note,
      createdAt: purchaseList.createdAt,
    );
  }
}
