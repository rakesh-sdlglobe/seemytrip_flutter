class BusSearchResult {
  final String busOperatorName;
  final String busNumber;
  final String fromCityName;
  final String toCityName;
  final String journeyDate;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String fare;
  final String busType;
  final int availableSeats;
  final bool hasWiFi;
  final bool hasCharger;
  final bool hasBlanket;
  final bool hasWaterBottle;
  final bool hasSnacks;
  final String traceId;
  final int resultIndex;

  BusSearchResult({
    required this.busOperatorName,
    required this.busNumber,
    required this.fromCityName,
    required this.toCityName,
    required this.journeyDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fare,
    required this.busType,
    required this.availableSeats,
    required this.hasWiFi,
    required this.hasCharger,
    required this.hasBlanket,
    required this.hasWaterBottle,
    required this.hasSnacks,
    required this.traceId,
    required this.resultIndex,
  });
}

class Bus {
  final String busId;
  final String busNumber;
  final String fromCityName;
  final String toCityName;
  final String journeyDate;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String fare;
  final String busType;
  final String busOperatorName;
  final int availableSeats;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.fromCityName,
    required this.toCityName,
    required this.journeyDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fare,
    required this.busType,
    required this.busOperatorName,
    required this.availableSeats,
  });
}

class BusCity {
  final String id;
  final String name;
  final String? code;  // Optional field for city code
  final String? state;  // Optional field for state
  final double? lat;    // Optional latitude
  final double? long;   // Optional longitude

  BusCity({
    required this.id,
    required this.name,
    this.code,
    this.state,
    this.lat,
    this.long,
  });

  // Factory method to create a BusCity from JSON
  factory BusCity.fromJson(Map<String, dynamic> json) {
    return BusCity(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      code: json['code'],
      state: json['state'],
      lat: json['lat']?.toDouble(),
      long: json['long']?.toDouble(),
    );
  }

  // Convert BusCity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'state': state,
      'lat': lat,
      'long': long,
    };
  }
}
