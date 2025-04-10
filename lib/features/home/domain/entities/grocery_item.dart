import 'package:equatable/equatable.dart';

/// Represents a grocery item in a shopping list
///
/// [GroceryItem] is used to track grocery items that a user wants to purchase or has already purchased.
/// It contains details like name, quantity, price, category, and purchase status.
class GroceryItem extends Equatable {
  /// Unique identifier for the grocery item
  final String id;

  /// Name of the grocery item
  final String name;

  /// Quantity of the grocery item (e.g., 2, 0.5)
  final double quantity;

  /// Unit of measurement (e.g., kg, pcs, l)
  final String unit;

  /// Price per unit
  final double unitPrice;

  /// Total price (unitPrice * quantity)
  final double totalPrice;

  /// Category of the item (e.g., dairy, produce, meat)
  final String category;

  /// Optional note about the item
  final String note;

  /// Whether the item has been purchased
  final bool isPurchased;

  /// When the item was added to the list
  final DateTime createdAt;

  /// When the item was purchased (null if not purchased)
  final DateTime? purchasedAt;

  /// Price at which the item was actually purchased (null if not purchased)
  final double? purchasedPrice;

  /// Creates a new grocery item
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.category,
    this.note = '',
    this.isPurchased = false,
    required this.createdAt,
    this.purchasedAt,
    this.purchasedPrice,
  }) : totalPrice = unitPrice * quantity;

  /// Creates a copy of this grocery item with the given fields replaced
  GroceryItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    double? unitPrice,
    String? category,
    String? note,
    bool? isPurchased,
    DateTime? createdAt,
    DateTime? purchasedAt,
    double? purchasedPrice,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      category: category ?? this.category,
      note: note ?? this.note,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt ?? this.createdAt,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      purchasedPrice: purchasedPrice ?? this.purchasedPrice,
    );
  }

  /// Returns a grocery item marked as purchased at the current time
  GroceryItem markAsPurchased({double? actualPrice}) {
    return copyWith(
      isPurchased: true,
      purchasedAt: DateTime.now(),
      purchasedPrice: actualPrice,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        unit,
        unitPrice,
        totalPrice,
        category,
        note,
        isPurchased,
        createdAt,
        purchasedAt,
        purchasedPrice,
      ];
}
