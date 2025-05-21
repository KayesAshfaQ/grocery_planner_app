import 'package:equatable/equatable.dart';
import 'package:grocery_planner_app/features/dashboard/domain/entity/purchase_item.dart';

/// Database model for purchase lists
class PurchaseList extends Equatable {
  /// Primary key identifier for the purchase list
  final int? id;

  /// Name of the purchase list
  final String name;

  /// Optional budget for this purchase list
  final double? budget;

  /// List of items in this purchase list
  final List<PurchaseItem> purchaseItems;

  /// Optional note about this purchase list
  final String? note;

  /// Timestamp when this list was created
  final String createdAt;

  const PurchaseList({
    this.id,
    required this.name,
    this.budget,
    required this.purchaseItems,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        budget,
        purchaseItems,
        note,
        createdAt,
      ];
}
