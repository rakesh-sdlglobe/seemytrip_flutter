class FlightModel {
  final String? airlineName;
  final String? flightNumber;
  final String? departureAirport;
  final String? arrivalAirport;
  final String? departureTime;
  final String? arrivalTime;
  final String? duration;
  final double? price;
  final String? currency;
  final String? cabinClass;

  FlightModel({
    this.airlineName,
    this.flightNumber,
    this.departureAirport,
    this.arrivalAirport,
    this.departureTime,
    this.arrivalTime,
    this.duration,
    this.price,
    this.currency,
    this.cabinClass,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    // You'll need to adjust these mappings based on your actual API response structure
    return FlightModel(
      airlineName: json['AirlineName'] as String?,
      flightNumber: json['FlightNumber'] as String?,
      departureAirport: json['DepartureAirport'] as String?,
      arrivalAirport: json['ArrivalAirport'] as String?,
      departureTime: json['DepartureTime'] as String?,
      arrivalTime: json['ArrivalTime'] as String?,
      duration: json['Duration'] as String?,
      price: (json['Price'] as num?)?.toDouble(),
      currency: json['Currency'] as String?,
      cabinClass: json['CabinClass'] as String?,
    );
  }
}
