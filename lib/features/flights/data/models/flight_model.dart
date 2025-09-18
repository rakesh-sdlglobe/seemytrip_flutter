class FlightSearchResponse {
  final List<dynamic>? flightResults;
  final Map<String, dynamic>? filter;
  final String? statusMessage;

  FlightSearchResponse({
    this.flightResults,
    this.filter,
    this.statusMessage,
  });

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) {
    return FlightSearchResponse(
      flightResults: json['FlightResults'] as List<dynamic>?, // match backend key
      filter: json['Filter'] as Map<String, dynamic>?,        // match backend key
      statusMessage: json['StatusMessage']?.toString(),       // backend may or may not send
    );
  }

  Map<String, dynamic> toJson() => {
        'FlightResults': flightResults,
        'Filter': filter,
        'StatusMessage': statusMessage,
      };
}

class FlightModel {

  FlightModel({
    this.airline,
    this.fromAirport,
    this.toAirport,
    this.departTime,
    this.arrivalTime,
    this.price,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      airline: json['Airline']?.toString(),
      fromAirport: json['FromAirport']?.toString(),
      toAirport: json['ToAirport']?.toString(),
      departTime: json['DepartTime']?.toString(),
      arrivalTime: json['ArrivalTime']?.toString(),
      price: json['Price'] != null
          ? double.tryParse(json['Price'].toString())
          : null,
    );
  }
  final String? airline;
  final String? fromAirport;
  final String? toAirport;
  final String? departTime;
  final String? arrivalTime;
  final double? price;

  Map<String, dynamic> toJson() => {
        'Airline': airline,
        'FromAirport': fromAirport,
        'ToAirport': toAirport,
        'DepartTime': departTime,
        'ArrivalTime': arrivalTime,
        'Price': price,
      };
}
