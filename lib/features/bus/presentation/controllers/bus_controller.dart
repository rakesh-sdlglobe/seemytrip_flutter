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
  Rxn<BoardingPointResponse> boardingPointsResponse =
      Rxn<BoardingPointResponse>();

  // Store search response and params for retry after session expiry
  // ignore: unused_field
  Map<String, dynamic>? _storedSearchResponse;
  Map<String, dynamic>? _storedSearchParams;

  // Getter for stored search response (used in booking flow)
  Map<String, dynamic>? get storedSearchResponse => _storedSearchResponse;

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
      final http.Response response =
          await http.post(url, headers: headers, body: body);

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
      final http.Response response =
          await http.post(url, headers: headers, body: body);

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
              final Map<String, dynamic> busJson =
                  busData as Map<String, dynamic>;
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

          // Store search response for retry after session expiry
          _storedSearchResponse = responseData;
          _storedSearchParams = <String, dynamic>{
            'DateOfJourney': dateOfJourney,
            'DestinationId': destinationId,
            'EndUserIp': endUserIp,
            'OriginId': originId,
            'BookingMode': bookingMode,
            'TokenId': tokenId,
            'PreferredCurrency': preferredCurrency,
          };

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

        // Check for error and retry if needed
        // React logic: ErrorCode === 5 || ErrorMessage includes 'token' or 'trace'
        final error = data['Error'];
        if (error != null) {
          final int errorCode = error['ErrorCode'] is int
              ? error['ErrorCode']
              : int.tryParse(error['ErrorCode'].toString()) ?? 0;
          final String errorMessage =
              (error['ErrorMessage'] ?? '').toString().toLowerCase();

          if (errorCode == 5 ||
              errorMessage.contains('token') ||
              errorMessage.contains('trace')) {
            print(
                'Token/Trace error in seat layout (Code: $errorCode, Msg: $errorMessage), refreshing and retrying...');

            // Re-authenticate
            await authenticateBusAPI();
            if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
              throw Exception("Failed to re-authenticate for seat layout");
            }

            // Re-search to get new TraceId
            if (_storedSearchParams != null) {
              final Map<String, dynamic> newSearchParams =
                  Map<String, dynamic>.from(_storedSearchParams!);
              newSearchParams['TokenId'] = tokenId.value;
              newSearchParams['EndUserIp'] = endUserIp.value;

              print('Re-searching buses to get new TraceId...');
              final http.Response searchResponse = await http.post(
                Uri.parse(AppConfig.busSearch),
                headers: <String, String>{'Content-Type': 'application/json'},
                body: jsonEncode(newSearchParams),
              );

              if (searchResponse.statusCode == 200) {
                final searchData = jsonDecode(searchResponse.body);
                final String? newTraceId =
                    searchData['BusSearchResult']?['TraceId']?.toString();

                if (newTraceId != null && newTraceId.isNotEmpty) {
                  print('New TraceId obtained: $newTraceId');
                  _storedSearchResponse = searchData;

                  // Retry seat layout with new credentials
                  print('Retrying seat layout with new TraceId...');
                  final http.Response retryResponse = await http.post(
                    Uri.parse(AppConfig.busSeatLayout),
                    headers: <String, String>{
                      'Content-Type': 'application/json'
                    },
                    body: jsonEncode(<String, Object>{
                      'IpAddress': endUserIp.value,
                      'ResultIndex': resultIndex,
                      'TraceId': newTraceId,
                      'TokenId': tokenId.value,
                    }),
                  );

                  if (retryResponse.statusCode == 200) {
                    final retryData = json.decode(retryResponse.body);
                    print('Bus seat layout data (Retry): $retryData');
                    return retryData;
                  } else {
                    print(
                        'Retry failed with status: ${retryResponse.statusCode}');
                  }
                } else {
                  print('Failed to get new TraceId from search response');
                }
              } else {
                print(
                    'Failed to re-search buses: ${searchResponse.statusCode}');
              }
            } else {
              print('No stored search params available for retry');
            }
          }
        }

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
        Uri.parse(AppConfig.busBoardingPoints),
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
              (result['BoardingPointsDetails'] as List? ?? <dynamic>[])
                  .map((bp) => BoardingPoint(
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
                      ))
                  .toList();

          // Parse dropping points
          final List<BoardingPoint> droppingPoints =
              (result['DroppingPointsDetails'] as List? ?? <dynamic>[])
                  .map((dp) => BoardingPoint(
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
                      ))
                  .toList();

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

  // Block bus seats before booking
  Future<Map<String, dynamic>?> blockBus({
    required String traceId,
    required int resultIndex,
    required String boardingPointId,
    required String droppingPointId,
    required List<Map<String, dynamic>> passengers,
  }) async {
    try {
      isLoading(true);

      print('BUS BLOCK START');
      print('traceId: $traceId | resultIndex: $resultIndex');
      print('boarding: $boardingPointId | dropping: $droppingPointId');

      if (traceId.isEmpty) throw Exception('TraceId missing');

      // Ensure auth
      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        await authenticateBusAPI();
      }
      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        throw Exception('Auth failed');
      }

      // Convert IDs
      final int? boardingId = int.tryParse(boardingPointId);
      final int? droppingId = int.tryParse(droppingPointId);

      if (boardingId == null) throw Exception('Invalid BoardingPointId');
      if (droppingId == null) throw Exception('Invalid DroppingPointId');

      // ----------------------------------------------------
      // 1. Get fresh seat layout
      // ----------------------------------------------------
      print('Fetching fresh seat layout...');
      final Map<String, dynamic>? freshLayout =
          await getBusSeatLayout(traceId, resultIndex);

      final layout = freshLayout?['GetBusSeatLayOutResult'];
      final seatDetails = layout?['SeatLayoutDetails'];

      if (seatDetails == null) throw Exception('Seat layout missing');

      // Extract fresh seat data
      final Map<String, Map<String, dynamic>> seatsMap =
          <String, Map<String, dynamic>>{};
      final layoutData = seatDetails['SeatLayout'] ?? seatDetails['Seat'];

      if (layoutData != null) {
        final List list =
            layoutData is List ? layoutData : <dynamic>[layoutData];
        for (var seat in list) {
          if (seat['SeatName'] != null) {
            seatsMap[seat['SeatName'].toString()] = seat;
          }
        }
      }

      // Fallback: use input seat data
      if (seatsMap.isEmpty) {
        for (Map<String, dynamic> p in passengers) {
          final Map<String, dynamic> s = p['Seat'] as Map<String, dynamic>;
          seatsMap[s['SeatName'].toString()] = s;
        }
        print('⚠ Using fallback seat data');
      }

      print('Fresh seats loaded: ${seatsMap.keys.toList()}');

      // ----------------------------------------------------
      // 2. Validate passengers & rebuild with fresh data
      // ----------------------------------------------------
      final List<Map<String, dynamic>> validated = <Map<String, dynamic>>[];

      for (int i = 0; i < passengers.length; i++) {
        final Map<String, dynamic> p = passengers[i];
        final inputSeat = p['Seat'];
        final String seatName = inputSeat['SeatName'].toString();
        final Map<String, dynamic>? freshSeat = seatsMap[seatName];

        if (freshSeat == null) throw Exception('Seat $seatName missing');

        // Check availability
        final bool isBooked = freshSeat['IsBooked'] == true ||
            freshSeat['IsAvailable'] == false ||
            freshSeat['SeatStatus'] == 'Booked';

        if (isBooked) throw Exception('Seat $seatName is no longer available');

        final price = freshSeat['Price'];
        final double fare = (price?['PublishedPrice'] ?? 0).toDouble();
        final int gender = int.parse(p['Gender'].toString());
        final int age = int.parse(p['Age'].toString());
        final String title = gender == 1 ? 'Mr' : 'Ms';

        validated.add(<String, dynamic>{
          'PassengerId': p['PassengerId'] ?? i + 1,
          'Title': title,
          'FirstName': p['FirstName'],
          'LastName': p['LastName'],
          'Age': age,
          'Gender': gender,
          'Phoneno': p['Phoneno'],
          'Email': p['Email'],
          'SeatId': freshSeat['SeatIndex'],
          'SeatNo': seatName,
          'IsPrimaryPax': true, // FIX APPLIED
          "LeadPassenger": true,
          'Fare': <String, num>{'BaseFare': fare, 'Tax': 0},
          'Seat': <String, dynamic>{
            'SeatIndex': freshSeat['SeatIndex'],
            'SeatName': seatName,
            'SeatType': freshSeat['SeatType'] ?? 'Seater',
            'SeatStatus': 'Available',
            'PublishedPrice': fare,
            'SeatFare': fare,
            'Price': price,
          }
        });
      }

      // ----------------------------------------------------
      // 3. Build request body
      // ----------------------------------------------------
      final Map<String, Object> body = <String, Object>{
        'TokenId': tokenId.value,
        'TraceId': traceId,
        'EndUserIp': endUserIp.value,
        'ResultIndex': resultIndex,
        'BoardingPointId': boardingId,
        'DroppingPointId': droppingId,
        'Passenger': validated,
      };

      print('BLOCK REQUEST: ${jsonEncode(body)}');

      // ----------------------------------------------------
      // 4. Call API
      // ----------------------------------------------------
      final http.Response res = await http.post(
        Uri.parse(AppConfig.busBlock),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('STATUS: ${res.statusCode}');
      print('RESPONSE: ${res.body}');

      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      final block = data['BlockResult'];

      if (block == null) throw Exception('Invalid block response');

      if (block['ResponseStatus'] != 1) {
        throw Exception(block['Error']?['ErrorMessage'] ?? 'Block failed');
      }

      print('BLOCK SUCCESS');
      return data;
    } catch (e) {
      print('BLOCK EXCEPTION: $e');
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Book bus after blocking
  Future<Map<String, dynamic>?> bookBus({
    required String traceId,
    required int resultIndex,
    required String boardingPointId,
    required String droppingPointId,
    required List<Map<String, dynamic>> passengers,
  }) async {
    try {
      isLoading(true);
      print('bookBus called with:');
      print('traceId: $traceId');
      print('resultIndex: $resultIndex');
      print('boardingPointId: $boardingPointId');
      print('droppingPointId: $droppingPointId');
      print('passengers: ${passengers.length}');

      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        await authenticateBusAPI();
      }

      final List<Map<String, dynamic>> validatedPassengers =
          <Map<String, dynamic>>[];
      for (Map<String, dynamic> passenger in passengers) {
        // Ensure Title is present and valid
        String title = passenger['Title'] ?? '';
        if (title.isEmpty) {
          final gender = passenger['Gender'];
          if (gender == 1 || gender == '1') {
            title = 'Mr';
          } else if (gender == 2 || gender == '2') {
            title =
                'Ms'; // Or Mrs based on age/status if available, but Ms is safer default
          } else {
            title = 'Mr'; // Fallback
          }
        }

        validatedPassengers.add(<String, dynamic>{
          'Title': title,
          'FirstName': passenger['FirstName'],
          'LastName': passenger['LastName'],
          'Age': passenger['Age'],
          'Gender': passenger['Gender'],
          'Phoneno': passenger['Phoneno'],
          'Email': passenger['Email'],
          'Seat': passenger['Seat'],
          'PassengerId': passenger['PassengerId'],
          // Add other necessary fields if any
        });
      }

      final Map<String, dynamic> requestBody = <String, dynamic>{
        'TokenId': tokenId.value,
        'TraceId': traceId,
        'EndUserIp': endUserIp.value,
        'ResultIndex': resultIndex,
        'BoardingPointId': boardingPointId,
        'DroppingPointId': droppingPointId,
        'Passenger': validatedPassengers,
      };

      print('Book request body: ${jsonEncode(requestBody)}');

      final http.Response response = await http.post(
        Uri.parse(AppConfig.busBook),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Book response status: ${response.statusCode}');
      print('Book response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookResult = data['BookResult'];

        // Check for session expiry error (ErrorCode 5)
        if (bookResult != null &&
            bookResult['Error'] != null &&
            bookResult['Error']['ErrorCode'] == 5) {
          print('Session expired (ErrorCode 5), refreshing and retrying...');

          // Re-authenticate
          await authenticateBusAPI();
          if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
            throw Exception('Failed to re-authenticate for booking');
          }

          // Re-search to get new TraceId
          if (_storedSearchParams != null) {
            final Map<String, dynamic> newSearchParams =
                Map<String, dynamic>.from(_storedSearchParams!);
            newSearchParams['TokenId'] = tokenId.value;
            newSearchParams['EndUserIp'] = endUserIp.value;

            // Re-search buses to get new TraceId
            final http.Response searchResponse = await http.post(
              Uri.parse(AppConfig.busSearch),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(newSearchParams),
            );

            if (searchResponse.statusCode == 200) {
              final searchData = jsonDecode(searchResponse.body);
              final String? newTraceId =
                  searchData['BusSearchResult']?['TraceId']?.toString();

              if (newTraceId == null || newTraceId.isEmpty) {
                throw Exception('Failed to get new TraceId for booking');
              }

              // Update stored search response
              _storedSearchResponse = searchData;

              // Retry booking with new credentials
              final Map<String, dynamic> retryRequestBody = <String, dynamic>{
                'TokenId': tokenId.value,
                'TraceId': newTraceId,
                'EndUserIp': endUserIp.value,
                'ResultIndex': resultIndex,
                'BoardingPointId': boardingPointId,
                'DroppingPointId': droppingPointId,
                'Passenger': passengers,
              };

              print('Retrying booking with new TraceId: $newTraceId');
              final http.Response retryResponse = await http.post(
                Uri.parse(AppConfig.busBook),
                headers: <String, String>{'Content-Type': 'application/json'},
                body: jsonEncode(retryRequestBody),
              );

              if (retryResponse.statusCode == 200) {
                final retryData = jsonDecode(retryResponse.body);
                final retryBookResult = retryData['BookResult'];

                if (retryBookResult != null &&
                    retryBookResult['ResponseStatus'] == 1 &&
                    (retryBookResult['Error'] == null ||
                        retryBookResult['Error']['ErrorCode'] == 0 ||
                        retryBookResult['Error']['ErrorCode'] == null)) {
                  print('Bus booked successfully after retry');
                  return retryData;
                } else {
                  final errorMessage = retryBookResult?['Error']
                          ?['ErrorMessage'] ??
                      'Booking failed after retry';
                  Get.snackbar(
                    'Booking Failed',
                    errorMessage,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 4),
                  );
                  return null;
                }
              } else {
                final errorData = jsonDecode(retryResponse.body);
                final errorMessage =
                    errorData['message'] ?? 'Failed to book bus after retry';
                Get.snackbar(
                  'Error',
                  errorMessage,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 4),
                );
                return null;
              }
            } else {
              throw Exception('Failed to re-search buses for new TraceId');
            }
          } else {
            throw Exception('No stored search params available for retry');
          }
        }

        // Check if booking was successful
        if (bookResult != null &&
            bookResult['ResponseStatus'] == 1 &&
            (bookResult['Error'] == null ||
                bookResult['Error']['ErrorCode'] == 0 ||
                bookResult['Error']['ErrorCode'] == null)) {
          print('Bus booked successfully');
          return data;
        } else {
          final errorMessage =
              bookResult?['Error']?['ErrorMessage'] ?? 'Booking failed';
          Get.snackbar(
            'Booking Failed',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
          return null;
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to book bus';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error booking bus: $e');
      Get.snackbar(
        'Error',
        'An error occurred while booking bus: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Get booking details
  Future<Map<String, dynamic>?> getBookingDetails({
    required String traceId,
    required String busId,
    bool isBaseCurrencyRequired = false,
  }) async {
    try {
      isLoading(true);
      print('getBookingDetails called with:');
      print('traceId: $traceId');
      print('busId: $busId');

      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        await authenticateBusAPI();
      }

      final Map<String, dynamic> requestBody = <String, dynamic>{
        'TokenId': tokenId.value,
        'TraceId': traceId,
        'EndUserIp': endUserIp.value,
        'BusId': busId,
        'IsBaseCurrencyRequired': isBaseCurrencyRequired,
      };

      final http.Response response = await http.post(
        Uri.parse(AppConfig.busBookingDetails),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Booking details response status: ${response.statusCode}');
      print('Booking details response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to get booking details';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error getting booking details: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting booking details: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Cancel bus booking
  Future<Map<String, dynamic>?> cancelBusBooking({
    required String busId,
    required String agencyId,
    required String requestType,
    required String remarks,
  }) async {
    try {
      isLoading(true);
      print('cancelBusBooking called with:');
      print('busId: $busId');
      print('agencyId: $agencyId');
      print('requestType: $requestType');

      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        await authenticateBusAPI();
      }

      final Map<String, dynamic> requestBody = <String, dynamic>{
        'TokenId': tokenId.value,
        'EndUserIp': endUserIp.value,
        'BusId': busId,
        'AgencyId': agencyId,
        'RequestType': requestType,
        'Remarks': remarks,
      };

      final http.Response response = await http.post(
        Uri.parse(AppConfig.busBookingCancel),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Cancel booking response status: ${response.statusCode}');
      print('Cancel booking response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Success',
          'Booking cancellation request submitted',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to cancel booking';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error cancelling bus booking: $e');
      Get.snackbar(
        'Error',
        'An error occurred while cancelling booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Create bus booking in database
  Future<Map<String, dynamic>?> createBusBooking({
    required int? userId,
    required Map<String, dynamic> busData,
    required Map<String, dynamic> blockData,
    required Map<String, dynamic> contactDetails,
    required Map<String, dynamic> addressDetails,
    required Map<String, dynamic> travelerDetails,
    required Map<String, dynamic> fareDetails,
    Map<String, dynamic>? searchResponse,
  }) async {
    try {
      isLoading(true);
      print('createBusBooking called');

      // Extract journey date from busData
      String? journeyDate;
      if (busData.containsKey('JourneyDate')) {
        journeyDate = busData['JourneyDate'];
      } else if (busData.containsKey('journey_date')) {
        journeyDate = busData['journey_date'];
      } else if (busData.containsKey('DepartureTime')) {
        try {
          final departureTime = busData['DepartureTime'];
          if (departureTime != null) {
            if (departureTime.toString().contains('T')) {
              journeyDate = departureTime.toString().split('T')[0];
            } else {
              // If DepartureTime is just time, we need the date from somewhere else.
              // Try to use stored search params if available
              if (_storedSearchParams != null &&
                  _storedSearchParams!.containsKey('DateOfJourney')) {
                journeyDate = _storedSearchParams!['DateOfJourney'];
                // Convert DD/MM/YYYY to YYYY-MM-DD if needed
                if (journeyDate!.contains('/')) {
                  final parts = journeyDate.split('/');
                  if (parts.length == 3) {
                    journeyDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                  }
                }
              }
            }
          }
        } catch (_) {}
      }

      // Fallback: if journeyDate is still null, try to find it in searchResponse
      if (journeyDate == null && searchResponse != null) {
        // Logic to find date in searchResponse if structure allows
      }

      // Ensure journeyDate is in YYYY-MM-DD format
      if (journeyDate != null && journeyDate.contains('/')) {
        final parts = journeyDate.split('/');
        if (parts.length == 3) {
          journeyDate = '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }

      print('DEBUG: busData keys: ${busData.keys}');
      print('DEBUG: busData content: $busData');
      print('DEBUG: Resolved journeyDate: $journeyDate');

      // Helper to ensure full datetime string
      String ensureDateTime(String? timeStr, String dateStr) {
        if (timeStr == null || timeStr.isEmpty) return '';
        if (timeStr.contains('T') || timeStr.contains(' '))
          return timeStr; // Already full datetime
        if (dateStr.isEmpty) return timeStr; // Can't fix without date
        return '$dateStr $timeStr:00'; // Append date to time
      }

      // Construct the exact structure expected by the backend
      // Backend expects: busBookingDetails -> GetBookingDetailResult -> Itinerary

      // Build Itinerary object
      final itinerary = {
        'Origin': busData['Origin'] ?? busData['Source'] ?? '',
        'Destination': busData['Destination'] ?? '',
        'TravelName': busData['TravelName'] ?? busData['TravelsName'] ?? '',
        'BusType': busData['BusType'] ?? '',
        'DepartureTime':
            ensureDateTime(busData['DepartureTime'], journeyDate ?? ''),
        'ArrivalTime': ensureDateTime(
            busData['ArrivalTime'],
            journeyDate ??
                ''), // Note: Arrival might be next day, but for now using journeyDate is better than invalid time
        'DateOfJourney': journeyDate ?? '',
        'BusId': busData['BusId'] ?? blockData['BlockResult']?['BusId'] ?? 0,
        'TicketNo': blockData['BlockResult']?['TicketNo'] ?? '',
        'TravelOperatorPNR':
            blockData['BlockResult']?['TravelOperatorPNR'] ?? '',
        'InvoiceNumber': blockData['BlockResult']?['InvoiceNumber'] ?? '',
        'InvoiceAmount': blockData['BlockResult']?['InvoiceAmount'] ?? 0,
        'Status': 2, // Confirmed
        'Passenger': travelerDetails['passengers'] ??
            [], // Ensure this matches backend structure
        'Price': fareDetails,
        'BoardingPointdetails': {
          'CityPointLocation': busData['BoardingPoint'] ?? '',
          'CityPointTime':
              ensureDateTime(busData['BoardingTime'], journeyDate ?? '')
        },
        'DroppingPointdetails': {
          'CityPointLocation': busData['DroppingPoint'] ?? '',
          'CityPointTime':
              ensureDateTime(busData['DroppingTime'], journeyDate ?? '')
        }
      };

      final busBookingDetails = {
        'GetBookingDetailResult': {'Itinerary': itinerary}
      };

      final Map<String, dynamic> requestBody = <String, dynamic>{
        'user_id': userId,
        'busBookingDetails': busBookingDetails,
        'payment_status': 'Completed', // Assuming payment is done
        'payment_transaction_id':
            'TXN_${DateTime.now().millisecondsSinceEpoch}', // Placeholder or actual ID
      };

      print('Create booking request body keys: ${requestBody.keys}');

      final http.Response response = await http.post(
        Uri.parse(AppConfig.createBusBooking),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Create booking response status: ${response.statusCode}');
      print('Create booking response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Bus booking created successfully in database');
        Get.snackbar(
          'Success',
          'Booking saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to create booking';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error creating bus booking: $e');
      Get.snackbar(
        'Error',
        'An error occurred while creating booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Get user bus bookings
  Future<List<Map<String, dynamic>>?> getUserBusBookings(int userId) async {
    try {
      isLoading(true);
      print('getUserBusBookings called for userId: $userId');

      final http.Response response = await http.get(
        Uri.parse(AppConfig.getUserBusBookings(userId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('Get user bookings response status: ${response.statusCode}');
      print('Get user bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['bookings'] != null) {
          final List<dynamic> bookings = data['bookings'];
          return bookings.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to get bookings';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error getting user bus bookings: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting bookings: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Get bus booking details by booking ID
  Future<Map<String, dynamic>?> getBusBookingDetailsById(
      String bookingId) async {
    try {
      isLoading(true);
      print('getBusBookingDetailsById called for bookingId: $bookingId');

      final http.Response response = await http.get(
        Uri.parse(AppConfig.getBusBookingDetailsById(bookingId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('Get booking details response status: ${response.statusCode}');
      print('Get booking details response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data;
        }
        return null;
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Not Found',
          'Booking not found',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to get booking details';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error getting bus booking details: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting booking details: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Update bus booking status
  Future<bool> updateBusBookingStatus({
    required String bookingId,
    required String bookingStatus,
    required String paymentStatus,
    String? ticketNo,
    String? travelOperatorPnr,
  }) async {
    try {
      isLoading(true);
      print('updateBusBookingStatus called for bookingId: $bookingId');

      final Map<String, dynamic> requestBody = <String, dynamic>{
        'booking_status': bookingStatus,
        'payment_status': paymentStatus,
        'ticket_no': ticketNo,
        'travel_operator_pnr': travelOperatorPnr,
      };

      final http.Response response = await http.put(
        Uri.parse(AppConfig.updateBusBookingStatus(bookingId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Update booking status response status: ${response.statusCode}');
      print('Update booking status response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Get.snackbar(
            'Success',
            'Booking status updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return true;
        }
        return false;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to update booking status';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return false;
      }
    } catch (e) {
      print('Error updating bus booking status: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating booking status: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Cancel bus booking in database
  Future<bool> cancelBusBookingById(String bookingId) async {
    try {
      isLoading(true);
      print('cancelBusBookingById called for bookingId: $bookingId');

      final http.Response response = await http.put(
        Uri.parse(AppConfig.cancelBusBookingById(bookingId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('Cancel booking response status: ${response.statusCode}');
      print('Cancel booking response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Get.snackbar(
            'Success',
            'Booking cancelled successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return true;
        }
        return false;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to cancel booking';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return false;
      }
    } catch (e) {
      print('Error cancelling bus booking: $e');
      Get.snackbar(
        'Error',
        'An error occurred while cancelling booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Get bus booking statistics
  Future<Map<String, dynamic>?> getBusBookingStats(int userId) async {
    try {
      isLoading(true);
      print('getBusBookingStats called for userId: $userId');

      final http.Response response = await http.get(
        Uri.parse(AppConfig.getBusBookingStats(userId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      print('Get booking stats response status: ${response.statusCode}');
      print('Get booking stats response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['stats'] != null) {
          return data['stats'] as Map<String, dynamic>;
        }
        return null;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to get booking stats';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }
    } catch (e) {
      print('Error getting bus booking stats: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting booking stats: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return null;
    } finally {
      isLoading(false);
    }
  }
}
