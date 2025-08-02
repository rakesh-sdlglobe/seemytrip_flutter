
// In search_city_controller.dart
class GeoLocation {
  final String hotelProviderSearchId;
  final String hotelName;
  final double latitude;
  final double longitude;
  final String address;
  final double price;

  GeoLocation({
    required this.hotelProviderSearchId,
    required this.hotelName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.price,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      hotelProviderSearchId: json['HotelProviderSearchId'] ?? '',
      hotelName: json['HotelName'] ?? '',
      latitude: double.tryParse(json['HotelAddress']['Latitude'] ?? '0') ?? 0,
      longitude: double.tryParse(json['HotelAddress']['Longitude'] ?? '0') ?? 0,
      address: json['HotelAddress']['Address'] ?? '',
      price: (json['LBookPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}