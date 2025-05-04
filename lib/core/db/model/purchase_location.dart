class PurchaseLocation {
  final int? locationId;
  final int listId;
  final double? latitude;
  final double? longitude;
  final String? address;

  PurchaseLocation({
    this.locationId,
    required this.listId,
    this.latitude,
    this.longitude,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'location_id': locationId,
      'list_id': listId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory PurchaseLocation.fromMap(Map<String, dynamic> map) {
    return PurchaseLocation(
      locationId: map['location_id'],
      listId: map['list_id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }
}
