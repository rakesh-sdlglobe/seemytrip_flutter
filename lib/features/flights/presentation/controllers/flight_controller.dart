import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../../data/models/flight_model.dart';
import '../screens/FlightSearchScreen/one_way_results_screen.dart';
import '../screens/FlightSearchScreen/round_trip_results_screen.dart';

class FlightController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Map<String, String>> airports = <Map<String, String>>[].obs;
  final RxMap<String, dynamic> flightResults = <String, dynamic>{}.obs;
  final RxDouble totalPrice = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  Map<String, dynamic> _lastSearchParams = {};

  Map<String, dynamic> getLastSearchParams() => _lastSearchParams;

  Future<void> searchAndShowFlights({
    required String fromAirportCode,
    required String toAirportCode,
    required String departDate,
    String? returnDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String flightType = 'O',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🛫 Starting flight search with parameters:');
      print('- From: $fromAirportCode');
      print('- To: $toAirportCode');
      print('- Depart: $departDate');
      print('- Return: $returnDate');
      print('- Passengers: $adults Adult(s), $children Child(ren), $infants Infant(s)');
      print('- Class: $travelClass');
      print('- Type: ${flightType == 'R' ? 'Round Trip' : 'One Way'}');

      _lastSearchParams = {
        'fromAirport': fromAirportCode,
        'toAirport': toAirportCode,
        'departDate': departDate,
        'returnDate': returnDate,
        'adults': adults,
        'infants': infants,
        'children': children,
        'youth': youth,
        'travelClass': travelClass,
        'flightType': flightType,
      };

      // Validate required fields
      if (fromAirportCode.isEmpty || toAirportCode.isEmpty || departDate.isEmpty) {
        throw Exception('Missing required fields: FromAirport, ToAirport, and DepartDate are required');
      }

      final response = await searchFlights(
        fromAirport: fromAirportCode,
        toAirport: toAirportCode,
        departDate: departDate,
        returnDate: flightType == 'R' ? returnDate : null,
        adults: adults,
        infants: infants,
        children: children,
        youth: youth,
        travelClass: travelClass,
        flightType: flightType,
      );

      print('✅ Flight search successful');
      flightResults.value = response.toJson();

      final bool hasResults = response.flightResults?.isNotEmpty ?? false;
      print('📊 Search results: ${hasResults ? 'Found flights' : 'No flights found'}');


      if (!hasResults) {
        Get.snackbar(
          'No Flights Found',
          response.statusMessage ?? 'No flights available for the selected criteria.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (flightType == 'R') {
        await Get.to(() => RoundTripResultsScreen(), arguments: {
          'flightData': response.toJson(),
          'searchParams': _lastSearchParams,
          'fromAirportCode': fromAirportCode,
          'toAirportCode': toAirportCode,
        });
      } else {
        await Get.to(() => OneWayResultsScreen(), arguments: {
          'flightData': response.toJson(),
          'searchParams': _lastSearchParams,
          'fromAirportCode': fromAirportCode,
          'toAirportCode': toAirportCode,
        });
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to search flights: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, String>>> fetchAirports() async {
    try {
      final String url = AppConfig.flightsAirports.replaceAll(r'$baseUrl', AppConfig.baseUrl);
      print('Fetching airports from: $url');
      
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> acList = data['AcList'] ?? <dynamic>[];
        
        final List<Map<String, String>> airportList = acList.map<Map<String, String>>((airport) {
          if (airport == null) return <String, String>{};
          return <String, String>{
            'id': airport['Id']?.toString() ?? '',
            'code': airport['Code']?.toString() ?? '',
            'name': airport['Name']?.toString() ?? '',
            'city': airport['Desc1']?.toString() ?? '',
            'countryCode': airport['Desc2']?.toString() ?? '',
            'display': airport['Display']?.toString() ?? '',
            'type': airport['Type']?.toString() ?? '',
          };
        }).where((Map<String, String> map) => map.isNotEmpty).toList();

        airports.assignAll(airportList);
        
        return airportList;
      } else {
        throw Exception('Failed to load airports: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error loading airports: ${e.toString()}';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<FlightSearchResponse> searchFlights({
    required String fromAirport,
    required String toAirport,
    required String departDate,
    String? returnDate,
    int adults = 1,
    int infants = 0,
    int children = 0,
    int youth = 0,
    String travelClass = 'E',
    String flightType = 'O',
    String currency = 'INR',
    int pageNo = 1,
    int pageSize = 10,
    String travellerNationality = 'IN',
    String serviceTypeCode = 'F',
  }) async {
    final requestBody = {
      'SessionID': null,
      'FromAirport': fromAirport, // must be code, like "DEL"
      'ToAirport': toAirport,     // must be code, like "DXB"
      'Class': travelClass,
      'DepartDate': departDate,
      if (flightType == 'R' && returnDate != null) 'ReturnDate': returnDate,
      'FlightType': flightType,
      'Adults': adults,
      'Infants': infants,
      'Children': children,
      'Youth': youth,
      'TravellerNationality': travellerNationality,
      'ServiceTypeCode': serviceTypeCode,
      'Currency': currency,
      'PageNo': pageNo,
      'PageSize': pageSize,
    };

    return await _makeFlightSearchRequest(requestBody);
  }

  Future<FlightSearchResponse> _makeFlightSearchRequest(Map<String, dynamic> requestBody) async {
    final url = '${AppConfig.baseUrl}/flights/getFlightsList';
    print('🚀 Flight search URL: $url');
    print('📤 Request body:');
    requestBody.forEach((key, value) => print('- $key: $value'));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(Duration(seconds: 30));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Empty response from server');
        }
        
        try {
          final responseData = jsonDecode(response.body);
          if (responseData is! Map<String, dynamic>) {
            throw FormatException('Invalid response format');
          }
          return FlightSearchResponse.fromJson(responseData);
        } catch (e) {
          print('❌ Error parsing response: $e');
          throw Exception('Error processing flight data. Please try again.');
        }
      } else {
        String errorMessage = 'Failed to load flights (Status: ${response.statusCode})';
        try {
          final error = jsonDecode(response.body);
          errorMessage = error['message']?.toString() ?? errorMessage;
        } catch (_) {
          // If we can't parse the error message, use the default one
        }
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('❌ HTTP Client Error: $e');
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } on FormatException catch (e) {
      print('❌ Format Error: $e');
      throw Exception('Error processing server response. Please try again.');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again later.');
    }
  }
}
