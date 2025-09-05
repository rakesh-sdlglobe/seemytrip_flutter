import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../domain/models/flight_segment.dart';
import '../screens/FlightSearchScreen/flight_results_screen.dart';
import '../screens/FlightSearchScreen/one_way_results_screen.dart';
import '../screens/FlightSearchScreen/round_trip_results_screen.dart';
import '../screens/FlightSearchScreen/multi_city_results_screen.dart';

class FlightController extends GetxController {
  // State variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, dynamic> flightResults = <String, dynamic>{}.obs;
  final RxList<dynamic> outboundFlights = <dynamic>[].obs;
  final RxList<dynamic> returnFlights = <dynamic>[].obs;
  
  // Multi-city segments
  final RxList<FlightSegment> flightSegments = <FlightSegment>[].obs;
  
  // Store last search parameters
  Map<String, dynamic>? _lastSearchParams;
  
  // Getter for last search parameters
  Map<String, dynamic> getLastSearchParams() => _lastSearchParams ?? {};
  
  // Retry last search
  Future<void> retryLastSearch() async {
    if (_lastSearchParams != null) {
      return searchAndShowFlights(
        fromAirport: _lastSearchParams!['fromAirport'],
        toAirport: _lastSearchParams!['toAirport'],
        departDate: _lastSearchParams!['departDate'],
        returnDate: _lastSearchParams!['returnDate'],
        adults: _lastSearchParams!['adults'] ?? 1,
        travelClass: _lastSearchParams!['travelClass'] ?? 'E',
        tripType: _lastSearchParams!['tripType'] ?? 'oneway',
      );
    }
  }
  
  // Navigation methods
  void navigateToResultsScreen(String tripType) {
    switch (tripType) {
      case 'oneway':
        Get.to(() => const OneWayResultsScreen());
        break;
      case 'roundtrip':
        Get.to(() => const RoundTripResultsScreen());
        break;
      case 'multicity':
        Get.to(() => const MultiCityResultsScreen());
        break;
    }
  }

  // Get results for a specific segment in multi-city search
  List<dynamic> getSegmentResults(String segmentId) {
    // Implement logic to get results for a specific segment
    return [];
  }

  // Search flights based on type (one-way or round-trip)
  // Search for multi-city flights
  Future<Map<String, dynamic>> searchMultiCityFlights({
    required List<Map<String, dynamic>> segments,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String currency = 'INR',
    String travellerNationality = 'IN',
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      isLoading.value = true;
      
      // Convert segments to the format expected by the backend
      final flightSegments = segments.map((segment) => {
        'FromAirport': segment['fromAirport'],
        'ToAirport': segment['toAirport'],
        'DepartDate': segment['departDate'],
        'RowNo': segment['rowNo'] ?? 0,
      }).toList();
      
      final requestBody = {
        'FromAirport': segments.isNotEmpty ? segments[0]['fromAirport'] : '',
        'ToAirport': segments.isNotEmpty ? segments[segments.length - 1]['toAirport'] : '',
        'Class': travelClass,
        'DepartDate': segments.isNotEmpty ? segments[0]['departDate'] : '',
        'ReturnDate': null,
        'Adults': adults,
        'Infants': infants,
        'Children': children,
        'Youth': youth,
        'TravellerNationality': travellerNationality,
        'ServiceTypeCode': 'F',
        'Currency': currency,
        'PageNo': pageNo,
        'PageSize': pageSize,
        'FlightType': 'M', // M for Multi-city
        'FlightSegments': flightSegments,
      };

      // Make the API request
      final response = await http.post(
        Uri.parse('$baseUrl/getFlightsList'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to search flights');
      }
    } catch (e) {
      print('Error in searchMultiCityFlights: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> searchFlights({
    required String fromAirport,
    required String toAirport,
    required String departDate,
    String? returnDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String flightType = 'R',
    String currency = 'INR',
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      if (flightType == 'R' && returnDate != null) {
        return await searchRoundTripFlights(
          fromAirport: fromAirport,
          toAirport: toAirport,
          departDate: departDate,
          returnDate: returnDate,
          adults: adults,
          infants: infants,
          children: children,
          youth: youth,
          travelClass: travelClass,
          currency: currency,
          pageNo: pageNo,
          pageSize: pageSize,
        );
      } else {
        return await searchOneWayFlights(
          fromAirport: fromAirport,
          toAirport: toAirport,
          departDate: departDate,
          adults: adults,
          infants: infants,
          children: children,
          youth: youth,
          travelClass: travelClass,
          currency: currency,
          pageNo: pageNo,
          pageSize: pageSize,
        );
      }
    } catch (e) {
      print('Error in searchFlights: $e');
      rethrow;
    }
  }

  // Search flights and navigate to results
  Future<void> searchAndShowFlights({
    required String fromAirport,
    required String toAirport,
    required String departDate,
    String? returnDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String flightType = 'R',
    required String tripType, // 'oneway', 'roundtrip', or 'multicity'
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Store search parameters for retry
      _lastSearchParams = {
        'fromAirport': fromAirport,
        'toAirport': toAirport,
        'departDate': departDate,
        'returnDate': returnDate,
        'adults': adults,
        'infants': infants,
        'children': children,
        'youth': youth,
        'travelClass': travelClass,
        'flightType': flightType,
        'tripType': tripType,
      };
      
      final results = await searchFlights(
        fromAirport: fromAirport,
        toAirport: toAirport,
        departDate: departDate,
        returnDate: returnDate,
        adults: adults,
        infants: infants,
        children: children,
        youth: youth,
        travelClass: travelClass,
        flightType: flightType,
      );
      
      // Print response based on trip type
      switch (tripType.toLowerCase()) {
        case 'oneway':
          print('\n=== One-Way Flight Search Results ===');
          print('From: $fromAirport, To: $toAirport, Date: $departDate');
          print('Passengers - Adults: $adults, Children: $children, Infants: $infants, Youth: $youth');
          print('Class: $travelClass');
          print('Status: ${results['status'] ?? 'N/A'}');
          if (results.containsKey('data') && results['data'] is Map) {
            final data = results['data'] as Map;
            print('Available Flights: ${data['availableFlights']?.length ?? 0}');
            print('Airlines: ${data['airlines']?.join(', ') ?? 'N/A'}');
          }
          break;
          
        case 'roundtrip':
          print('\n=== Round-Trip Flight Search Results ===');
          print('From: $fromAirport, To: $toAirport');
          print('Departure: $departDate, Return: $returnDate');
          print('Passengers - Adults: $adults, Children: $children, Infants: $infants, Youth: $youth');
          print('Class: $travelClass');
          print('Status: ${results['status'] ?? 'N/A'}');
          if (results.containsKey('data') && results['data'] is Map) {
            final data = results['data'] as Map;
            print('Outbound Flights: ${data['outboundFlights']?.length ?? 0}');
            print('Return Flights: ${data['returnFlights']?.length ?? 0}');
            print('Airlines: ${data['airlines']?.join(', ') ?? 'N/A'}');
          }
          break;
          
        case 'multicity':
          print('\n=== Multi-City Flight Search Results ===');
          print('Number of segments: ${flightSegments.length}');
          print('Total passengers - Adults: $adults, Children: $children, Infants: $infants, Youth: $youth');
          print('Class: $travelClass');
          print('Status: ${results['status'] ?? 'N/A'}');
          if (results.containsKey('data') && results['data'] is Map) {
            final data = results['data'] as Map;
            print('Total Flight Options: ${data['totalOptions'] ?? 'N/A'}');
            print('Airlines: ${data['airlines'] is List ? (data['airlines'] as List).join(', ') : 'N/A'}');
          }
          break;
          
        default:
          print('\n=== Unknown Trip Type: $tripType ===');
          print('Full response:');
          print(results);
      }
      
      flightResults.value = results;
      
      // Navigate to appropriate results screen based on trip type
      if (context != null) {
        switch (tripType.toLowerCase()) {
          case 'oneway':
            await Get.to(() => const OneWayResultsScreen());
            break;
          case 'roundtrip':
            await Get.to(() => const RoundTripResultsScreen());
            break;
          case 'multicity':
            await Get.to(() => const MultiCityResultsScreen());
            break;
          default:
            await Get.to(() => FlightResultsScreen(tripType: tripType));
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to search flights: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Context for navigation
  BuildContext? get context => Get.context;
  final String baseUrl = 'http://192.168.0.4:3002/api/flights';
  
  Future<List<Map<String, String>>> fetchAirports() async {
    try {
      print('Fetching airports from: $baseUrl/getFlightsAirports');
      final response = await http.post(
        Uri.parse('$baseUrl/getFlightsAirports'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> acList = data['AcList'] ?? [];
        
        return acList.map<Map<String, String>>((airport) {
          if (airport == null) return {};
          return {
            'id': airport['Id']?.toString() ?? '',
            'code': airport['Code']?.toString() ?? '',
            'name': airport['Name']?.toString() ?? '',
            'city': airport['Desc1']?.toString() ?? '',
            'countryCode': airport['Desc2']?.toString() ?? '',
            'display': airport['Display']?.toString() ?? '',
            'type': airport['Type']?.toString() ?? '',
          };
        }).where((map) => map.isNotEmpty).toList();
      } else {
        throw Exception('Failed to load airports: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in fetchAirports: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Common method to make the actual API request
  // Add a flight segment for multi-city search
  void addFlightSegment(String fromAirport, String toAirport, String departDate) {
    flightSegments.add(FlightSegment(
      fromAirport: '',
      toAirport: '',
      departDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      rowNo: flightSegments.length,
    ));
  }

  // Remove a flight segment by index
  void removeFlightSegment(int index) {
    if (index >= 0 && index < flightSegments.length) {
      flightSegments.removeAt(index);
      // Update row numbers
      for (var i = 0; i < flightSegments.length; i++) {
        flightSegments[i] = FlightSegment(
          fromAirport: flightSegments[i].fromAirport,
          toAirport: flightSegments[i].toAirport,
          departDate: flightSegments[i].departDate,
          rowNo: i,
        );
      }
    }
  }

  // Clear all flight segments
  void clearFlightSegments() {
    flightSegments.clear();
  }

  Future<Map<String, dynamic>> _makeFlightSearchRequest(Map<String, dynamic> requestBody) async {
    try {
      final url = Uri.parse('$baseUrl/getFlightsList');
      
      // Log request details
      print('=== Flight Search Request ===');
      print('URL: $url');
      print('Request: ${json.encode(requestBody)}');
      
      final stopwatch = Stopwatch()..start();
      
      // Make the HTTP request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      stopwatch.stop();
      
      // Log response details
      print('Response time: ${stopwatch.elapsedMilliseconds}ms');
      print('Status: ${response.statusCode}');
      print('Response: ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          // Log response structure
          print('Response keys: ${responseData.keys.join(', ')}');
          
          // Handle different response formats
          if (responseData.containsKey('FlightResults') && responseData['FlightResults'] is List) {
            final List<dynamic> flights = responseData['FlightResults'];
            print('Found ${flights.length} flights');
          } else if (responseData.containsKey('FlightGroupResults') && responseData['FlightGroupResults'] is List) {
            final List<dynamic> flightGroups = responseData['FlightGroupResults'];
            print('Found ${flightGroups.length} flight groups');
          } else if (responseData.containsKey('error')) {
            throw Exception(responseData['error']);
          }
          
          return responseData;
          
        } catch (e) {
          print('Error parsing response: $e');
          throw Exception('Failed to parse flight data: $e');
        }
      } else {
        String errorMessage = 'Failed to search flights';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Flight search error: $e');
      rethrow;
    }
  }

  // Search for one-way flights
  Future<Map<String, dynamic>> searchOneWayFlights({
    required String fromAirport,
    required String toAirport,
    required String departDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String currency = 'INR',
    int pageNo = 1,
    int pageSize = 10,
    String travellerNationality = 'IN',
    String serviceTypeCode = 'F',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('=== One-Way Flight Search ===');
      print('From: $fromAirport to $toAirport on $departDate');
      print('Passengers: Adults: $adults, Children: $children, Infants: $infants, Youth: $youth');
      print('Class: $travelClass');
      
      final Map<String, dynamic> requestBody = {
        'FromAirport': fromAirport,
        'ToAirport': toAirport,
        'DepartDate': departDate,
        'Adults': adults,
        'Infants': infants,
        'Children': children,
        'Youth': youth,
        'Class': travelClass,
        'Currency': currency,
        'PageNo': pageNo,
        'PageSize': pageSize,
        'TravellerNationality': travellerNationality,
        'ServiceTypeCode': serviceTypeCode,
        'FlightType': 'O', // O for One-way
      };

      final response = await _makeFlightSearchRequest(requestBody);
      
      // Update the outbound flights list
      if (response.containsKey('FlightResults') && response['FlightResults'] is List) {
        outboundFlights.value = response['FlightResults'];
      }
      
      return response;
    } catch (e) {
      errorMessage.value = 'Failed to search flights: $e';
      print('Error in searchOneWayFlights: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Search for round-trip flights
  Future<Map<String, dynamic>> searchRoundTripFlights({
    required String fromAirport,
    required String toAirport,
    required String departDate,
    required String returnDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String currency = 'INR',
    int pageNo = 1,
    int pageSize = 10,
    String travellerNationality = 'IN',
    String serviceTypeCode = 'F',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('=== Round-Trip Flight Search ===');
      print('From: $fromAirport to $toAirport');
      print('Departure: $departDate, Return: $returnDate');
      print('Passengers: Adults: $adults, Children: $children, Infants: $infants, Youth: $youth');
      print('Class: $travelClass');
      
      final Map<String, dynamic> requestBody = {
        'FromAirport': fromAirport,
        'ToAirport': toAirport,
        'DepartDate': departDate,
        'ReturnDate': returnDate,
        'Adults': adults,
        'Infants': infants,
        'Children': children,
        'Youth': youth,
        'Class': travelClass,
        'Currency': currency,
        'PageNo': pageNo,
        'PageSize': pageSize,
        'TravellerNationality': travellerNationality,
        'ServiceTypeCode': serviceTypeCode,
        'FlightType': 'R', // R for Round-trip
      };

      final response = await _makeFlightSearchRequest(requestBody);
      
      // Update the outbound and return flights lists
      if (response.containsKey('FlightResults') && response['FlightResults'] is List) {
        outboundFlights.value = response['FlightResults'];
      }
      
      if (response.containsKey('ReturnFlightResults') && response['ReturnFlightResults'] is List) {
        returnFlights.value = response['ReturnFlightResults'];
      }
      
      return response;
    } catch (e) {
      errorMessage.value = 'Failed to search flights: $e';
      print('Error in searchRoundTripFlights: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
