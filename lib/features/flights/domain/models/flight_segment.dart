class FlightSegment {
  final String fromAirport;
  final String toAirport;
  final String departDate;
  final int rowNo;

  FlightSegment({
    required this.fromAirport,
    required this.toAirport,
    required this.departDate,
    required this.rowNo,
  });

  FlightSegment copyWith({
    String? fromAirport,
    String? toAirport,
    String? departDate,
    int? rowNo,
  }) {
    return FlightSegment(
      fromAirport: fromAirport ?? this.fromAirport,
      toAirport: toAirport ?? this.toAirport,
      departDate: departDate ?? this.departDate,
      rowNo: rowNo ?? this.rowNo,
    );
  }

  Map<String, dynamic> toJson() => {
    'FromAirport': fromAirport,
    'ToAirport': toAirport,
    'DepartDate': departDate,
    'RowNo': rowNo,
  };
}
