import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../shared/models/bus_models.dart';
import '../screens/bus_search_results_screen.dart';

class BusController extends GetxController {
  RxString tokenId = ''.obs;
  RxString endUserIp = ''.obs;
  RxList<BusCity> busCities = <BusCity>[].obs;
  RxList cityList = <dynamic>[].obs;
  RxBool isLoading = false.obs;
  Rxn<BoardingPointResponse> boardingPointsResponse = Rxn<BoardingPointResponse>();

  @override
  void onInit() {
    super.onInit();
    authenticateBusAPI();
  }

  Future<void> authenticateBusAPI() async {
    isLoading(true);
    try {
      final http.Response response = await http.post(
        Uri.parse(AppConfig.busAuth),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tokenId.value = data['TokenId'] ?? '';
        endUserIp.value = data['EndUserIp'] ?? '';
        print('TOKEN ID: ${tokenId.value}, END USER IP: ${endUserIp.value}');

        if (tokenId.value.isNotEmpty && endUserIp.value.isNotEmpty) {
          await fetchCities(tokenId.value, endUserIp.value);
        } else {
          print('Token or IP is empty!');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    isLoading(false);
  }

  Future<void> fetchCities(String tokenId, String endUserIp) async {
    isLoading.value = true;

    final Uri url = Uri.parse(AppConfig.busCities);

    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Use exact key names as expected by backend
    final String body = jsonEncode(<String, String>{
      'TokenId': tokenId,
      'IpAddress': endUserIp,
    });

    print('Sending body: $body');

    try {
      final http.Response response = await http.post(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cityList.value = data['BusCities'] ?? <dynamic>[];
      } else {
        throw Exception('Failed to fetch bus cities');
      }
    } catch (e) {
      print('Error occurred while fetching cities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _calculateDuration(String? departureTime, String? arrivalTime) {
    try {
      if (departureTime == null || arrivalTime == null) return 'N/A';

      final DateTime departure = DateTime.parse(departureTime);
      final DateTime arrival = DateTime.parse(arrivalTime);
      final Duration difference = arrival.difference(departure);

      final int hours = difference.inHours;
      final int minutes = difference.inMinutes.remainder(60);

      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${minutes}m';
      }
    } catch (e) {
      print('Error calculating duration: $e');
      return 'N/A';
    }
  }

  Future<void> searchBuses({
    required String dateOfJourney,
    required int destinationId,
    required String endUserIp,
    required int originId,
    required int bookingMode,
    required String tokenId,
    required String preferredCurrency,
  }) async {
    final Uri url = Uri.parse(AppConfig.busSearch);

    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    print('searchBuses called with: ');
    print('dateOfJourney: $dateOfJourney');
    print('destinationId: $destinationId');
    print('endUserIp: $endUserIp');
    print('originId: $originId');
    print('bookingMode: $bookingMode');
    print('tokenId: $tokenId');
    print('preferredCurrency: $preferredCurrency');

    final String body = jsonEncode(<String, Object>{
      'DateOfJourney': dateOfJourney, // e.g. "2025-07-25"
      'DestinationId': destinationId,
      'EndUserIp': endUserIp,
      'OriginId': originId,
      'BookingMode': bookingMode,
      'TokenId': tokenId,
      'PreferredCurrency': preferredCurrency,
    });

    try {
      final http.Response response = await http.post(url, headers: headers, body: body);

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        print('Raw API Response: ${response.body}'); // Log the raw response

        try {
          final responseData = jsonDecode(response.body);
          print('Parsed Response: $responseData');

          final busSearchResult = responseData['BusSearchResult'];

          if (busSearchResult == null ||
              busSearchResult['BusResults'] == null) {
            print('Missing BusSearchResult or BusResults');
            Get.snackbar('Error', 'No bus results found',
                snackPosition: SnackPosition.BOTTOM);
            return;
          }

          final List<BusSearchResult> results = <BusSearchResult>[];

          for (var busData in busSearchResult['BusResults']) {
            try {
              final Map<String, dynamic> busJson = busData as Map<String, dynamic>;
              results.add(BusSearchResult(
                busOperatorName:
                    busJson['TravelName']?.toString() ?? 'Unknown Operator',
                busNumber: busJson['RouteId']?.toString() ?? 'N/A',
                fromCityName:
                    busSearchResult['Origin']?.toString() ?? 'Unknown Origin',
                toCityName: busSearchResult['Destination']?.toString() ??
                    'Unknown Destination',
                journeyDate:
                    busJson['DepartureTime']?.toString().split('T').first ??
                        'N/A',
                departureTime: busJson['DepartureTime']
                        ?.toString()
                        .split('T')
                        .last
                        .split('.')
                        .first ??
                    'N/A',
                arrivalTime: busJson['ArrivalTime']
                        ?.toString()
                        .split('T')
                        .last
                        .split('.')
                        .first ??
                    'N/A',
                duration: _calculateDuration(
                  busJson['DepartureTime']?.toString(),
                  busJson['ArrivalTime']?.toString(),
                ),
                fare: busJson['BusPrice']?['PublishedPriceRoundedOff']
                        ?.toString() ??
                    '0',
                busType: busJson['BusType']?.toString() ?? 'Bus',
                availableSeats: int.tryParse(
                        busJson['AvailableSeats']?.toString() ?? '0') ??
                    0,
                hasWiFi: busJson['HasWiFi']?.toString() == 'true' ||
                    busJson['HasWiFi']?.toString() == '1' ||
                    busJson['HasWiFi']?.toString().toLowerCase() == 'yes',
                hasCharger: busJson['HasCharger']?.toString() == 'true' ||
                    busJson['HasCharger']?.toString() == '1' ||
                    busJson['HasCharger']?.toString().toLowerCase() == 'yes',
                hasBlanket: busJson['HasBlanket']?.toString() == 'true' ||
                    busJson['HasBlanket']?.toString() == '1' ||
                    busJson['HasBlanket']?.toString().toLowerCase() == 'yes',
                hasWaterBottle:
                    busJson['HasWaterBottle']?.toString() == 'true' ||
                        busJson['HasWaterBottle']?.toString() == '1' ||
                        busJson['HasWaterBottle']?.toString().toLowerCase() ==
                            'yes',
                hasSnacks: busJson['HasSnacks']?.toString() == 'true' ||
                    busJson['HasSnacks']?.toString() == '1' ||
                    busJson['HasSnacks']?.toString().toLowerCase() == 'yes',
                traceId: busSearchResult['TraceId']?.toString() ?? '',
                resultIndex:
                    busJson['ResultIndex'] is int ? busJson['ResultIndex'] : 0,
              ));
            } catch (e) {
              print('Error parsing bus data: $e');
              print('Problematic bus data: $busData');
            }
          }

          // Navigate to the results screen with the parsed data
          if (results.isNotEmpty) {
            await Get.to(
              () => BusSearchResultsScreen(
                args: BusSearchResultsScreenArguments(
                  results: results,
                  fromLocation:
                      busSearchResult['Origin']?.toString() ?? 'Origin',
                  toLocation: busSearchResult['Destination']?.toString() ??
                      'Destination',
                  travelDate: DateTime.tryParse(
                          busSearchResult['JourneyDate']?.toString() ?? '') ??
                      DateTime.now(),
                ),
              ),
            );
          } else {
            Get.snackbar(
              'No Buses Found',
              'No buses available for the selected route and date.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          }
        } catch (e) {
          print('Error processing response: $e');
          Get.snackbar(
            'Error',
            'Failed to process bus data. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        print('API Error - Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to fetch buses. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<Map<String, dynamic>?> getBusSeatLayout(
      String traceId, int resultIndex) async {
    if (tokenId.value.isEmpty) {
      await authenticateBusAPI();
    }
    print('getBusSeatLayout called with: ');
    print('traceId: $traceId');
    print('resultIndex: $resultIndex');
    print('tokenId: ${tokenId.value}');
    print('endUserIp: ${endUserIp.value}');

    try {
      final http.Response response = await http.post(
        Uri.parse(AppConfig.busSeatLayout),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, Object>{
          'IpAddress': endUserIp.value,
          'ResultIndex': resultIndex,
          'TraceId': traceId,
          'TokenId': tokenId.value,
        }),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Bus seat layout data: $data');
        return data;
      } else {
        print('Failed to fetch seat layout. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to fetch seat layout. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error fetching seat layout: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching seat layout: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    }
  }

  // Fetch boarding point details for a specific bus
  Future<BoardingPointResponse?> getBoardingPoints({
    required String traceId,
    required int resultIndex,
  }) async {
    try {
      isLoading(true);
      print('getBoardingPoints called with: ');
      print('traceId: $traceId');
      print('resultIndex: $resultIndex');
      print('tokenId: ${tokenId.value}');
      print('endUserIp: ${endUserIp.value}');

      final http.Response response = await http.post(
        Uri.parse(
            AppConfig.busBoardingPoints),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, Object>{
          'IpAddress': endUserIp.value,
          'ResultIndex': resultIndex,
          'TraceId': traceId,
          'TokenId': tokenId.value,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final result = responseData['GetBusRouteDetailResult'];

        if (result != null && result['ResponseStatus'] == 1) {
          // Parse boarding points
          final List<BoardingPoint> boardingPoints =
              (result['BoardingPointsDetails'] as List? ?? <dynamic>[]).map((bp) => BoardingPoint(
              id: bp['CityPointIndex']?.toString() ?? '',
              location: bp['CityPointLocation'] ?? '',
              address: bp['CityPointAddress'] ?? '',
              contactNumber: bp['CityPointContactNumber'] ?? '',
              time: bp['CityPointTime'] ?? '--:--',
              landmark: bp['CityPointLandmark'] ?? '',
              name: bp['CityPointName'] ?? 'Unknown',
              latitude: 0.0,
              longitude: 0.0,
              isDefault: bp['IsDefault'] ?? false,
            )).toList();

          // Parse dropping points
          final List<BoardingPoint> droppingPoints =
              (result['DroppingPointsDetails'] as List? ?? <dynamic>[]).map((dp) => BoardingPoint(
              id: dp['CityPointIndex']?.toString() ?? '',
              location: dp['CityPointLocation'] ?? '',
              address: dp['CityPointAddress'] ?? '',
              contactNumber: dp['CityPointContactNumber'] ?? '',
              time: dp['CityPointTime'] ?? '--:--',
              landmark: dp['CityPointLandmark'] ?? '',
              name: dp['CityPointName'] ?? 'Unknown',
              latitude: 0.0,
              longitude: 0.0,
              isDefault: dp['IsDefault'] ?? false,
            )).toList();

          // Create a response object with both boarding and dropping points
          final BoardingPointResponse boardingResponse = BoardingPointResponse(
            status: true,
            boardingPoints: boardingPoints,
            droppingPoints: droppingPoints,
            message: 'Successfully loaded boarding and dropping points',
          );

          boardingPointsResponse.value = boardingResponse;
          print(
              'Successfully parsed ${boardingPoints.length} boarding points and ${droppingPoints.length} dropping points');
          return boardingResponse;
        } else {
          final errorMsg = result?['Error']?['ErrorMessage'] ??
              'Failed to load boarding points';
          print('Failed to load boarding points: $errorMsg');
          Get.snackbar(
            'Error',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
      } else {
        throw Exception(
            'Failed to load boarding points: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching boarding points: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching boarding points: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading(false);
    }
  }
}
