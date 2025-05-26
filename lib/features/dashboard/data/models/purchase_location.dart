import 'package:floor/floor.dart';

/// Database model for purchase locations
@Entity(tableName: 'purchase_locations')
class PurchaseLocation {
  /// Primary key identifier for the location
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Foreign key reference to the purchase list this location is for
  @ColumnInfo(name: 'list_id')
  final int listId;

  /// Optional latitude coordinate
  @ColumnInfo(name: 'latitude')
  final double? latitude;

  /// Optional longitude coordinate
  @ColumnInfo(name: 'longitude')
  final double? longitude;

  /// Optional address information
  @ColumnInfo(name: 'address')
  final String? address;

  PurchaseLocation({
    this.id,
    required this.listId,
    this.latitude,
    this.longitude,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'location_id': id,
      'list_id': listId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory PurchaseLocation.fromMap(Map<String, dynamic> map) {
    return PurchaseLocation(
      id: map['location_id'],
      listId: map['list_id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }
}
