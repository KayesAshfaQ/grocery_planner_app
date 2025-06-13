import 'package:floor/floor.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';

/// Database model for items in a purchase list
@Entity(tableName: 'purchase_list_items')
class PurchaseItemModel {
  /// Primary key identifier for the purchase list item
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Foreign key reference to the purchase list this item belongs to
  @ColumnInfo(name: 'list_id')
  final int listId;

  /// Optional foreign key reference to the catalog item this purchase is based on
  @ColumnInfo(name: 'catalog_id')
  final int? catalogId;

  /// Optional custom name for the item (overrides catalog name)
  @ColumnInfo(name: 'custom_name')
  final String? customName;

  /// Quantity of the item to purchase
  @ColumnInfo(name: 'quantity')
  final double quantity;

  /// Optional unit price of the item
  @ColumnInfo(name: 'unit_price')
  final double? unitPrice;

  /// Optional total price (overrides quantity*unit_price if specified)
  @ColumnInfo(name: 'total_price')
  final double? totalPrice;

  /// Optional note about this item
  @ColumnInfo(name: 'note')
  final String? note;

  /// Whether the item has been purchased
  @ColumnInfo(name: 'is_purchased')
  final bool isPurchased;

  /// Timestamp when the item was marked as purchased (nullable)
  @ColumnInfo(name: 'purchased_at')
  final String? purchasedAt;

  PurchaseItemModel({
    this.id,
    required this.listId,
    this.catalogId,
    this.customName,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.note,
    required this.isPurchased,
    this.purchasedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': id,
      'list_id': listId,
      'catalog_id': catalogId,
      'custom_name': customName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'note': note,
      'is_purchased': isPurchased ? 1 : 0,
      'purchased_at': purchasedAt,
    };
  }

  factory PurchaseItemModel.fromMap(Map<String, dynamic> map) {
    return PurchaseItemModel(
      id: map['item_id'],
      listId: map['list_id'],
      catalogId: map['catalog_id'],
      customName: map['custom_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      totalPrice: map['total_price'],
      note: map['note'],
      isPurchased: map['is_purchased'] == 1,
      purchasedAt: map['purchased_at'] != null ? map['purchased_at'] : null,
    );
  }

  // Converts the model to a domain entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'listId': listId,
      'catalogId': catalogId,
      'customName': customName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'note': note,
      'isPurchased': isPurchased,
      'purchasedAt': purchasedAt,
    };
  }

  /// fromEntity factory constructor to create a model from a domain entity
  factory PurchaseItemModel.fromEntity(PurchaseItem item) {
    return PurchaseItemModel(
      id: item.id,
      listId: item.listId,
      catalogId: item.catalogItem?.id,
      customName: item.customName,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalPrice: item.totalPrice,
      note: item.note,
      isPurchased: item.isPurchased,
      purchasedAt: item.purchasedAt,
    );
  }
}
