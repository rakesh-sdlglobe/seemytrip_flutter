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

class BoardingPoint {
  final String id;
  final String location;
  final String address;
  final String contactNumber;
  final String time;
  final String landmark;
  final String name;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String? cityPointId;
  final String? cityPointType;
  final String? cityPointContactPerson;
  final String? cityPointLandmark;
  final String? cityPointTime;
  final String? cityPointAddress;
  final String? cityPointLocation;
  final String? cityPointName;
  final String? cityPointContactNumber;
  final String? cityPointIndex;
  final String? cityPointLandMark;
  final String? cityPointLandmark1;
  final String? cityPointLandmark2;
  final String? cityPointLandmark3;
  final String? cityPointLandmark4;
  final String? cityPointLandmark5;
  final String? cityPointLandmark6;
  final String? cityPointLandmark7;
  final String? cityPointLandmark8;
  final String? cityPointLandmark9;
  final String? cityPointLandmark10;

  BoardingPoint({
    required this.id,
    required this.location,
    required this.address,
    required this.contactNumber,
    required this.time,
    required this.landmark,
    required this.name,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isDefault = false,
    this.cityPointId,
    this.cityPointType,
    this.cityPointContactPerson,
    this.cityPointLandmark,
    this.cityPointTime,
    this.cityPointAddress,
    this.cityPointLocation,
    this.cityPointName,
    this.cityPointContactNumber,
    this.cityPointIndex,
    this.cityPointLandMark,
    this.cityPointLandmark1,
    this.cityPointLandmark2,
    this.cityPointLandmark3,
    this.cityPointLandmark4,
    this.cityPointLandmark5,
    this.cityPointLandmark6,
    this.cityPointLandmark7,
    this.cityPointLandmark8,
    this.cityPointLandmark9,
    this.cityPointLandmark10,
  });

  factory BoardingPoint.fromJson(Map<String, dynamic> json) {
    // Try to extract coordinates from location string if available
    double? parseLatLong(String? location) {
      if (location == null) return 0.0;
      try {
        final parts = location.split(',');
        if (parts.length == 2) {
          return double.tryParse(parts[0].trim()) ?? 0.0;
        }
      } catch (e) {
        print('Error parsing location: $e');
      }
      return 0.0;
    }

    final location = json['CityPointLocation']?.toString() ?? '';
    final address = json['CityPointAddress']?.toString() ?? '';
    final contactNumber = json['CityPointContactNumber']?.toString() ?? '';
    final time = json['CityPointTime']?.toString() ?? '';
    final landmark = json['CityPointLandmark']?.toString() ?? '';
    final name = json['CityPointName']?.toString() ?? '';
    final id = json['CityPointIndex']?.toString() ?? '';
    
    return BoardingPoint(
      id: id,
      location: location,
      address: address,
      contactNumber: contactNumber,
      time: time,
      landmark: landmark,
      name: name,
      latitude: parseLatLong(location) ?? 0.0,
      longitude: parseLatLong(location) != null ? parseLatLong(location)! : 0.0,
      isDefault: json['IsDefault']?.toString().toLowerCase() == 'true',
      cityPointId: json['CityPointId']?.toString(),
      cityPointType: json['CityPointType']?.toString(),
      cityPointContactPerson: json['CityPointContactPerson']?.toString(),
      cityPointLandmark: landmark,
      cityPointTime: time,
      cityPointAddress: address,
      cityPointLocation: location,
      cityPointName: name,
      cityPointContactNumber: contactNumber,
      cityPointIndex: id,
      cityPointLandMark: landmark,
      cityPointLandmark1: json['CityPointLandmark1']?.toString(),
      cityPointLandmark2: json['CityPointLandmark2']?.toString(),
      cityPointLandmark3: json['CityPointLandmark3']?.toString(),
      cityPointLandmark4: json['CityPointLandmark4']?.toString(),
      cityPointLandmark5: json['CityPointLandmark5']?.toString(),
      cityPointLandmark6: json['CityPointLandmark6']?.toString(),
      cityPointLandmark7: json['CityPointLandmark7']?.toString(),
      cityPointLandmark8: json['CityPointLandmark8']?.toString(),
      cityPointLandmark9: json['CityPointLandmark9']?.toString(),
      cityPointLandmark10: json['CityPointLandmark10']?.toString(),
    );
  }
  
  // Convert to JSON for API requests if needed
  Map<String, dynamic> toJson() {
    return {
      'CityPointId': cityPointId,
      'CityPointType': cityPointType,
      'CityPointContactPerson': cityPointContactPerson,
      'CityPointLandmark': cityPointLandmark,
      'CityPointTime': cityPointTime,
      'CityPointAddress': cityPointAddress,
      'CityPointLocation': cityPointLocation,
      'CityPointName': cityPointName,
      'CityPointContactNumber': cityPointContactNumber,
      'CityPointIndex': cityPointIndex,
      'IsDefault': isDefault.toString(),
    };
  }
}

class BoardingPointResponse {
  final List<BoardingPoint> boardingPoints;
  final List<BoardingPoint> droppingPoints;
  final String message;
  final bool status;
  final String? traceId;
  final String? responseCode;
  final String? responseMessage;
  final Map<String, dynamic>? rawResponse;

  BoardingPointResponse({
    required this.boardingPoints,
    this.droppingPoints = const [],
    required this.message,
    required this.status,
    this.traceId,
    this.responseCode,
    this.responseMessage,
    this.rawResponse,
  });

  factory BoardingPointResponse.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse list of boarding/dropping points
    List<BoardingPoint> parsePoints(List<dynamic>? points) {
      if (points == null) return [];
      return points.map<BoardingPoint>((point) {
        if (point is Map<String, dynamic>) {
          return BoardingPoint.fromJson(point);
        }
        return BoardingPoint(
          id: '',
          location: '',
          address: '',
          contactNumber: '',
          time: '',
          landmark: '',
          name: '',
        );
      }).toList();
    }

    // Handle different response formats
    if (json['Response'] is Map) {
      // Standard response format with BoardingPointDetails and DroppingPointDetails
      return BoardingPointResponse(
        boardingPoints: parsePoints(json['Response']['BoardingPointDetails'] as List?),
        droppingPoints: parsePoints(json['Response']['DroppingPointDetails'] as List?),
        message: json['Message']?.toString() ?? '',
        status: json['Status']?.toString().toLowerCase() == 'true',
        traceId: json['TraceId']?.toString(),
        responseCode: json['ResponseCode']?.toString(),
        responseMessage: json['ResponseMessage']?.toString(),
        rawResponse: json,
      );
    } else {
      // Fallback for different response format
      return BoardingPointResponse(
        boardingPoints: parsePoints(json['BoardingPoints'] as List?),
        droppingPoints: parsePoints(json['DroppingPoints'] as List?),
        message: json['message']?.toString() ?? json['Message']?.toString() ?? '',
        status: json['status']?.toString().toLowerCase() == 'true' || 
                json['Status']?.toString().toLowerCase() == 'true',
        traceId: json['traceId']?.toString() ?? json['TraceId']?.toString(),
        responseCode: json['responseCode']?.toString() ?? json['ResponseCode']?.toString(),
        responseMessage: json['responseMessage']?.toString() ?? json['ResponseMessage']?.toString(),
        rawResponse: json,
      );
    }
  }
  
  // Convert to JSON for debugging or API requests
  Map<String, dynamic> toJson() {
    return {
      'BoardingPoints': boardingPoints.map((e) => e.toJson()).toList(),
      'DroppingPoints': droppingPoints.map((e) => e.toJson()).toList(),
      'Message': message,
      'Status': status,
      'TraceId': traceId,
      'ResponseCode': responseCode,
      'ResponseMessage': responseMessage,
    };
  }
}