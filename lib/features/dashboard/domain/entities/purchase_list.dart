import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entities/purchase_item.dart';

/// Database model for purchase lists
class PurchaseList extends Equatable {
  /// Primary key identifier for the purchase list
  final int? id;

  /// Name of the purchase list
  final String? name;

  /// Indicates whether this purchase list is completed
  final bool? isCompleted;

  /// Optional budget for this purchase list
  final double? budget;

  /// Optional currency symbol for the budget
  final String? currencySymbol;

  /// List of items in this purchase list
  final List<PurchaseItem> purchaseItems;

  /// Optional note about this purchase list
  final String? note;

  /// Timestamp when this list was created
  final String? createdAt;

  const PurchaseList({
    this.id,
    this.name,
    this.isCompleted = false,
    this.budget,
    this.currencySymbol,
    this.purchaseItems = const [],
    this.note,
    this.createdAt,
  });

  /// Creates a copy of this PurchaseList with the given fields replaced with the new values
  PurchaseList copyWith({
    int? id,
    String? name,
    bool? isCompleted,
    double? budget,
    String? currencySymbol,
    List<PurchaseItem>? purchaseItems,
    String? note,
    String? createdAt,
  }) {
    return PurchaseList(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      budget: budget ?? this.budget,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      purchaseItems: purchaseItems ?? this.purchaseItems,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        isCompleted,
        budget,
        currencySymbol,
        purchaseItems,
        note,
        createdAt,
      ];
}
