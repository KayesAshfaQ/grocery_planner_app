
import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/grocery_item.dart';

@Entity(tableName: 'grocery_items')
class GroceryItemModel {

  /// Primary key
  @primaryKey
  final String id;

  /// Name of the grocery item
  final String name;
  
  /// Quantity of the grocery item
  final double quantity;

  /// Unit of measurement
  final String unit;

  /// Price per unit
  final double unitPrice;

  /// Category of the item
  final String category;

  /// Optional note about the item
  final String? note;

  /// Whether the item has been purchased
  final bool isPurchased;

  /// When the item was added to the list (in milliseconds since epoch)
  final int createdAtMillis;

  /// When the item was purchased (in milliseconds since epoch, nullable)
  final int? purchasedAtMillis;

  /// Price at which the item was actually purchased (nullable)
  final double? purchasedPrice;

  /// Creates a new grocery item model
  GroceryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.category,
    this.note,
    required this.isPurchased,
    required this.createdAtMillis,
    this.purchasedAtMillis,
    this.purchasedPrice,
  });

  /// Converts this model to a domain entity
  GroceryItem toEntity() {
    return GroceryItem(
      id: id,
      name: name,
      quantity: quantity,
      unit: unit,
      unitPrice: unitPrice,
      category: category,
      note: note ?? '',
      isPurchased: isPurchased,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      purchasedAt: purchasedAtMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(purchasedAtMillis!)
          : null,
      purchasedPrice: purchasedPrice,
    );
  }

  /// Creates a model from a domain entity
  factory GroceryItemModel.fromEntity(GroceryItem entity) {
    return GroceryItemModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      unit: entity.unit,
      unitPrice: entity.unitPrice,
      category: entity.category,
      note: entity.note,
      isPurchased: entity.isPurchased,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
      purchasedAtMillis: entity.purchasedAt?.millisecondsSinceEpoch,
      purchasedPrice: entity.purchasedPrice,
    );
  }
}