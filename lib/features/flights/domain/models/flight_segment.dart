class FlightSegment {
  final String? airlineCode;
  final String? flightNumber;
  final String? departureAirport;
  final String? arrivalAirport;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final Duration? duration;
  final String? aircraftType;
  final String? cabinClass;
  final String? bookingClass;
  final int? stops;

  FlightSegment({
    this.airlineCode,
    this.flightNumber,
    this.departureAirport,
    this.arrivalAirport,
    this.departureTime,
    this.arrivalTime,
    this.duration,
    this.aircraftType,
    this.cabinClass,
    this.bookingClass,
    this.stops = 0,
  });

  // Optional: Add fromJson and toJson methods if you're working with API responses
  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      airlineCode: json['airlineCode'],
      flightNumber: json['flightNumber'],
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      departureTime: json['departureTime'] != null 
          ? DateTime.parse(json['departureTime']) 
          : null,
      arrivalTime: json['arrivalTime'] != null 
          ? DateTime.parse(json['arrivalTime']) 
          : null,
      duration: json['duration'] != null 
          ? Duration(minutes: json['duration'] as int) 
          : null,
      aircraftType: json['aircraftType'],
      cabinClass: json['cabinClass'],
      bookingClass: json['bookingClass'],
      stops: json['stops'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airlineCode': airlineCode,
      'flightNumber': flightNumber,
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'departureTime': departureTime?.toIso8601String(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'duration': duration?.inMinutes,
      'aircraftType': aircraftType,
      'cabinClass': cabinClass,
      'bookingClass': bookingClass,
      'stops': stops,
    };
  }
}
