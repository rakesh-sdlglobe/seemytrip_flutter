class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      double lat = _extractCoordinate(map, ['Latitude', 'latitude', 'lat']);
      double lng = _extractCoordinate(map, ['Longitude', 'longitude', 'lng', 'lon']);

      // Try nested 'location' or 'position' objects if direct keys fail
      if (lat == 0.0 && lng == 0.0) {
        final nestedMap = map['location'] ?? map['position'];
        if (nestedMap is Map) {
          final nestedStringMap = Map<String, dynamic>.from(nestedMap);
          lat = _extractCoordinate(nestedStringMap, ['lat', 'latitude']);
          lng = _extractCoordinate(nestedStringMap, ['lon', 'longitude']);
        }
      }

      final nameValue = map['HotelName'] ?? map['name'] ?? 'Unknown Location';

      return Location(
        name: nameValue.toString(),
        latitude: lat,
        longitude: lng,
      );
    }
    // Return a default invalid location if data cannot be parsed
    return Location(name: 'Invalid Data', latitude: 0.0, longitude: 0.0);
  }

  static double _extractCoordinate(Map<String, dynamic> map, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (map[key] != null) {
        final value = map[key];
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
      }
    }
    return 0.0;
  }
}
