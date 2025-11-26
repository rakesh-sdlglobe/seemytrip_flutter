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

          // Store search response for retry after session expiry
          _storedSearchResponse = responseData;
          _storedSearchParams = {
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
      
      print('[blockBus] Starting block bus request');
      print('[blockBus] Input params:');
      print('  - traceId: $traceId');
      print('  - resultIndex: $resultIndex');
      print('  - boardingPointId: $boardingPointId');
      print('  - droppingPointId: $droppingPointId');
      print('  - passengers count: ${passengers.length}');

      // Validate TraceId
      if (traceId.isEmpty) {
        print('[blockBus] ERROR: TraceId is missing or empty');
        throw Exception('TraceId is required for blocking bus seats');
      }

      // Authenticate if needed
      if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
        print('[blockBus] TokenId or EndUserIp missing, authenticating...');
        await authenticateBusAPI();
      }

      // Validate TokenId and EndUserIp
      if (tokenId.value.isEmpty) {
        print('[blockBus] ERROR: TokenId is missing or empty');
        throw Exception('TokenId is required for blocking bus seats');
      }

      if (endUserIp.value.isEmpty) {
        print('[blockBus] ERROR: EndUserIp is missing or empty');
        throw Exception('EndUserIp is required for blocking bus seats');
      }

      // Convert boarding and dropping point IDs to numbers
      final int? boardingPointIdInt = int.tryParse(boardingPointId);
      final int? droppingPointIdInt = int.tryParse(droppingPointId);

      if (boardingPointIdInt == null) {
        print('[blockBus] ERROR: Invalid BoardingPointId: $boardingPointId');
        throw Exception('BoardingPointId must be a valid number');
      }

      if (droppingPointIdInt == null) {
        print('[blockBus] ERROR: Invalid DroppingPointId: $droppingPointId');
        throw Exception('DroppingPointId must be a valid number');
      }

      // Transform passenger list from input format to TBO API format
      final List<Map<String, dynamic>> validatedPassengers = [];
      for (int i = 0; i < passengers.length; i++) {
        final passenger = passengers[i];
        print('[blockBus] Processing passenger ${i + 1}: $passenger');

        // Validate required input fields
        if (!passenger.containsKey('FirstName') || passenger['FirstName'] == null || passenger['FirstName'].toString().isEmpty) {
          throw Exception('Passenger ${i + 1}: FirstName is required');
        }
        if (!passenger.containsKey('LastName') || passenger['LastName'] == null || passenger['LastName'].toString().isEmpty) {
          throw Exception('Passenger ${i + 1}: LastName is required');
        }
        if (!passenger.containsKey('Age') || passenger['Age'] == null) {
          throw Exception('Passenger ${i + 1}: Age is required');
        }
        if (!passenger.containsKey('Gender') || passenger['Gender'] == null) {
          throw Exception('Passenger ${i + 1}: Gender is required');
        }
        if (!passenger.containsKey('Phoneno') || passenger['Phoneno'] == null || passenger['Phoneno'].toString().isEmpty) {
          throw Exception('Passenger ${i + 1}: Phoneno is required');
        }
        if (!passenger.containsKey('Email') || passenger['Email'] == null || passenger['Email'].toString().isEmpty) {
          throw Exception('Passenger ${i + 1}: Email is required');
        }
        if (!passenger.containsKey('Seat') || passenger['Seat'] == null) {
          throw Exception('Passenger ${i + 1}: Seat is required');
        }

        final seat = passenger['Seat'] as Map<String, dynamic>?;
        if (seat == null || seat.isEmpty) {
          throw Exception('Passenger ${i + 1}: Seat object is required');
        }

        if (!seat.containsKey('SeatName') || seat['SeatName'] == null || seat['SeatName'].toString().isEmpty) {
          throw Exception('Passenger ${i + 1}: Seat.SeatName is required');
        }

        if (!seat.containsKey('SeatFare') || seat['SeatFare'] == null) {
          throw Exception('Passenger ${i + 1}: Seat.SeatFare is required');
        }

        // Validate Gender is an integer (1 for Male, 0 for Female)
        final genderValue = passenger['Gender'] is int 
            ? passenger['Gender'] 
            : int.tryParse(passenger['Gender'].toString());
        if (genderValue == null || (genderValue != 1 && genderValue != 0)) {
          throw Exception('Passenger ${i + 1}: Gender must be 1 (Male) or 0 (Female)');
        }

        // Fetch PassengerId from traveler data if available, otherwise use index
        int passengerId;
        if (passenger.containsKey('PassengerId') && passenger['PassengerId'] != null) {
          // Use PassengerId directly if provided
          passengerId = passenger['PassengerId'] is int 
              ? passenger['PassengerId'] 
              : int.tryParse(passenger['PassengerId'].toString()) ?? i;
          print('[blockBus] Passenger ${i + 1}: Using PassengerId from data: $passengerId');
        } else if (passenger.containsKey('passengerId') && passenger['passengerId'] != null) {
          // Try lowercase passengerId
          passengerId = passenger['passengerId'] is int 
              ? passenger['passengerId'] 
              : int.tryParse(passenger['passengerId'].toString()) ?? i;
          print('[blockBus] Passenger ${i + 1}: Using passengerId from data: $passengerId');
        } else if (passenger.containsKey('id') && passenger['id'] != null) {
          // Try id field (common in traveler lists)
          passengerId = passenger['id'] is int 
              ? passenger['id'] 
              : int.tryParse(passenger['id'].toString()) ?? i;
          print('[blockBus] Passenger ${i + 1}: Using id from data: $passengerId');
        } else {
          // Fallback: Generate PassengerId from index (0, 1, 2, ...)
          passengerId = i;
          print('[blockBus] Passenger ${i + 1}: No PassengerId found, using index: $passengerId');
        }

        // Set Title based on Gender: "Mr" for 1 (Male), "Ms" for 0 (Female)
        final title = genderValue == 1 ? 'Mr' : 'Ms';

        // Extract SeatNo from Seat.SeatName
        final seatNo = seat['SeatName'].toString();

        // Extract BaseFare from Seat.SeatFare
        final baseFare = seat['SeatFare'] is num 
            ? seat['SeatFare'] 
            : double.tryParse(seat['SeatFare'].toString()) ?? 0.0;

        // Set Tax to 0 for now
        final tax = 0.0;

        // Parse Age
        final age = passenger['Age'] is int 
            ? passenger['Age'] 
            : int.tryParse(passenger['Age'].toString()) ?? 0;

        // Extract SeatIndex from Seat.SeatIndex (if available)
        final seatIndex = seat.containsKey('SeatIndex') && seat['SeatIndex'] != null
            ? (seat['SeatIndex'] is int 
                ? seat['SeatIndex'] 
                : int.tryParse(seat['SeatIndex'].toString()) ?? 0)
            : 0;

        // Build Seat object for backend validation
        final seatObject = <String, dynamic>{
          'SeatIndex': seatIndex,
          'SeatName': seatNo,
          if (seat.containsKey('SeatType')) 'SeatType': seat['SeatType'].toString(),
          if (seat.containsKey('SeatStatus')) 'SeatStatus': seat['SeatStatus'].toString(),
          if (seat.containsKey('PublishedPrice')) 'PublishedPrice': seat['PublishedPrice'] is num 
              ? seat['PublishedPrice'] 
              : double.tryParse(seat['PublishedPrice'].toString()) ?? baseFare,
          'SeatFare': baseFare,
        };

        // Build validated passenger object
        // Include Seat, Phoneno, Email for backend validation (backend should strip these before sending to TBO)
        // TBO API format: PassengerId, Title, FirstName, LastName, Age, Gender, SeatNo, Fare
        // Backend also requires: Seat, Phoneno, Email (for validation only)
        final validatedPassenger = <String, dynamic>{
          'PassengerId': passengerId,
          'Title': title,
          'FirstName': passenger['FirstName'].toString(),
          'LastName': passenger['LastName'].toString(),
          'Age': age,
          'Gender': genderValue,
          'SeatId': seatIndex, // Required by API - use SeatIndex as SeatId
          'Phoneno': passenger['Phoneno'].toString(), // Required by backend validation
          'Email': passenger['Email'].toString(), // Required by backend validation
          'Seat': seatObject, // Required by backend validation
          'SeatNo': seatNo, // Required by TBO API format
          'Fare': {
            'BaseFare': baseFare,
            'Tax': tax,
          },
        };

        validatedPassengers.add(validatedPassenger);
        print('[blockBus] Passenger ${i + 1} transformed successfully:');
        print('[blockBus]   - PassengerId: $passengerId');
        print('[blockBus]   - Title: $title');
        print('[blockBus]   - Name: ${passenger['FirstName']} ${passenger['LastName']}');
        print('[blockBus]   - Age: $age');
        print('[blockBus]   - Gender: $genderValue');
        print('[blockBus]   - SeatId: $seatIndex');
        print('[blockBus]   - Phoneno: ${passenger['Phoneno']}');
        print('[blockBus]   - Email: ${passenger['Email']}');
        print('[blockBus]   - Seat.SeatIndex: $seatIndex');
        print('[blockBus]   - Seat.SeatName: $seatNo');
        print('[blockBus]   - SeatNo: $seatNo');
        print('[blockBus]   - Fare.BaseFare: $baseFare');
        print('[blockBus]   - Fare.Tax: $tax');
        print('[blockBus]   Note: Backend should strip Seat/Phoneno/Email before sending to TBO');
      }

      // Build request body matching exact API format
      final requestBody = <String, dynamic>{
        'TokenId': tokenId.value,
        'TraceId': traceId,
        'EndUserIp': endUserIp.value,
        'ResultIndex': resultIndex,
        'BoardingPointId': boardingPointIdInt,
        'DroppingPointId': droppingPointIdInt,
        'Passenger': validatedPassengers,
      };

      print('[blockBus] Request body constructed:');
      print('[blockBus] ${jsonEncode(requestBody)}');

      // Make the API request
      final http.Response response = await http.post(
        Uri.parse(AppConfig.busBlock),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('[blockBus] Response status: ${response.statusCode}');
      print('[blockBus] Response body: ${response.body}');

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        print('[blockBus] ERROR: HTTP ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 
              errorData['error'] ?? 
              'Failed to block bus seats (HTTP ${response.statusCode})';
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        } catch (_) {
          Get.snackbar(
            'Error',
            'Failed to block bus seats (HTTP ${response.statusCode})',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        }
        return null;
      }

      // Parse response
      final data = jsonDecode(response.body);
      final blockResult = data['BlockResult'];

      // Check if BlockResult exists
      if (blockResult == null) {
        print('[blockBus] ERROR: BlockResult is null in response');
        Get.snackbar(
          'Error',
          'Invalid response format: BlockResult is missing',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }

      // Check for ErrorCode 5 (session expiry) - retry logic
      final error = blockResult['Error'];
      if (error != null && error['ErrorCode'] == 5) {
        print('[blockBus] Session expired (ErrorCode 5), refreshing and retrying...');
        
        // Re-authenticate
        await authenticateBusAPI();
        
        if (tokenId.value.isEmpty || endUserIp.value.isEmpty) {
          print('[blockBus] ERROR: Failed to re-authenticate');
          throw Exception('Failed to re-authenticate for block after session expiry');
        }

        // Re-search to get new TraceId
        if (_storedSearchParams == null) {
          print('[blockBus] ERROR: No stored search params available for retry');
          throw Exception('No stored search params available for retry after session expiry');
        }

        final newSearchParams = Map<String, dynamic>.from(_storedSearchParams!);
        newSearchParams['TokenId'] = tokenId.value;
        newSearchParams['EndUserIp'] = endUserIp.value;

        print('[blockBus] Re-searching buses to get new TraceId...');
        final searchResponse = await http.post(
          Uri.parse(AppConfig.busSearch),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(newSearchParams),
        );

        if (searchResponse.statusCode != 200) {
          print('[blockBus] ERROR: Failed to re-search buses (HTTP ${searchResponse.statusCode})');
          throw Exception('Failed to re-search buses for new TraceId');
        }

        final searchData = jsonDecode(searchResponse.body);
        final newTraceId = searchData['BusSearchResult']?['TraceId']?.toString();

        if (newTraceId == null || newTraceId.isEmpty) {
          print('[blockBus] ERROR: Failed to get new TraceId from search response');
          throw Exception('Failed to get new TraceId for block retry');
        }

        print('[blockBus] New TraceId obtained: $newTraceId');

        // Update stored search response
        _storedSearchResponse = searchData;

        // Build retry request body
        final retryRequestBody = <String, dynamic>{
          'TokenId': tokenId.value,
          'TraceId': newTraceId,
          'EndUserIp': endUserIp.value,
          'ResultIndex': resultIndex,
          'BoardingPointId': boardingPointIdInt,
          'DroppingPointId': droppingPointIdInt,
          'Passenger': validatedPassengers,
        };

        print('[blockBus] Retrying block with new TraceId...');
        print('[blockBus] Retry request body: ${jsonEncode(retryRequestBody)}');

        final retryResponse = await http.post(
          Uri.parse(AppConfig.busBlock),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(retryRequestBody),
        );

        print('[blockBus] Retry response status: ${retryResponse.statusCode}');
        print('[blockBus] Retry response body: ${retryResponse.body}');

        if (retryResponse.statusCode != 200) {
          print('[blockBus] ERROR: Retry failed with HTTP ${retryResponse.statusCode}');
          try {
            final errorData = jsonDecode(retryResponse.body);
            final errorMessage = errorData['message'] ?? 
                errorData['error'] ?? 
                'Failed to block bus seats after retry';
            Get.snackbar(
              'Error',
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          } catch (_) {
            Get.snackbar(
              'Error',
              'Failed to block bus seats after retry',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          }
          return null;
        }

        final retryData = jsonDecode(retryResponse.body);
        final retryBlockResult = retryData['BlockResult'];

        if (retryBlockResult == null) {
          print('[blockBus] ERROR: BlockResult is null in retry response');
          Get.snackbar(
            'Error',
            'Invalid response format: BlockResult is missing',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
          return null;
        }

        // Validate retry response status
        if (retryBlockResult['ResponseStatus'] != 1) {
          final errorMessage = retryBlockResult['Error']?['ErrorMessage'] ?? 
              'Failed to block bus seats after retry';
          print('[blockBus] ERROR: Retry failed - ResponseStatus: ${retryBlockResult['ResponseStatus']}');
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
          return null;
        }

        print('[blockBus] SUCCESS: Bus blocked successfully after retry');
        return retryData;
      }

      // Validate response status (must be 1 for success)
      final responseStatus = blockResult['ResponseStatus'];
      if (responseStatus != 1) {
        final errorMessage = blockResult['Error']?['ErrorMessage'] ?? 
            'Failed to block bus seats (ResponseStatus: $responseStatus)';
        print('[blockBus] ERROR: Block failed - ResponseStatus: $responseStatus');
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return null;
      }

      print('[blockBus] SUCCESS: Bus blocked successfully');
      return data;

    } catch (e) {
      print('[blockBus] EXCEPTION: $e');
      Get.snackbar(
        'Error',
        'An error occurred while blocking bus seats: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
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

      final requestBody = <String, dynamic>{
        'TokenId': tokenId.value,
        'TraceId': traceId,
        'EndUserIp': endUserIp.value,
        'ResultIndex': resultIndex,
        'BoardingPointId': boardingPointId,
        'DroppingPointId': droppingPointId,
        'Passenger': passengers,
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
            final newSearchParams = Map<String, dynamic>.from(_storedSearchParams!);
            newSearchParams['TokenId'] = tokenId.value;
            newSearchParams['EndUserIp'] = endUserIp.value;
            
            // Re-search buses to get new TraceId
            final searchResponse = await http.post(
              Uri.parse(AppConfig.busSearch),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(newSearchParams),
            );
            
            if (searchResponse.statusCode == 200) {
              final searchData = jsonDecode(searchResponse.body);
              final newTraceId = searchData['BusSearchResult']?['TraceId']?.toString();
              
              if (newTraceId == null || newTraceId.isEmpty) {
                throw Exception('Failed to get new TraceId for booking');
              }
              
              // Update stored search response
              _storedSearchResponse = searchData;
              
              // Retry booking with new credentials
              final retryRequestBody = <String, dynamic>{
                'TokenId': tokenId.value,
                'TraceId': newTraceId,
                'EndUserIp': endUserIp.value,
                'ResultIndex': resultIndex,
                'BoardingPointId': boardingPointId,
                'DroppingPointId': droppingPointId,
                'Passenger': passengers,
              };
              
              print('Retrying booking with new TraceId: $newTraceId');
              final retryResponse = await http.post(
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
                  final errorMessage = retryBookResult?['Error']?['ErrorMessage'] ?? 
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
                final errorMessage = errorData['message'] ?? 'Failed to book bus after retry';
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
          final errorMessage = bookResult?['Error']?['ErrorMessage'] ?? 'Booking failed';
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

      final requestBody = <String, dynamic>{
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
        final errorMessage = errorData['message'] ?? 'Failed to get booking details';
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

      final requestBody = <String, dynamic>{
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

      final requestBody = <String, dynamic>{
        'user_id': userId,
        'busData': busData,
        'blockData': blockData,
        'contactDetails': contactDetails,
        'addressDetails': addressDetails,
        'travelerDetails': travelerDetails,
        'fareDetails': fareDetails,
        if (searchResponse != null) 'searchResponse': searchResponse,
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
        return [];
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
  Future<Map<String, dynamic>?> getBusBookingDetailsById(String bookingId) async {
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
        final errorMessage = errorData['message'] ?? 'Failed to get booking details';
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

      final requestBody = <String, dynamic>{
        'booking_status': bookingStatus,
        'payment_status': paymentStatus,
        if (ticketNo != null) 'ticket_no': ticketNo,
        if (travelOperatorPnr != null) 'travel_operator_pnr': travelOperatorPnr,
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
        final errorMessage = errorData['message'] ?? 'Failed to update booking status';
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
        final errorMessage = errorData['message'] ?? 'Failed to get booking stats';
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
