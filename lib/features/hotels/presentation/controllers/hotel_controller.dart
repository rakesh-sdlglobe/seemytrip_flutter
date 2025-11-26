import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../shared/models/hotel_geolocation_model.dart';
import '../screens/hotel_detail_screen.dart';
import '../screens/hotel_image_screen.dart';
import '../screens/hotel_map_screen.dart';
import '../screens/hotel_screen.dart';

class City {
  final String id;
  final String name;
  final String country;

  City({required this.id, required this.name, this.country = ''});

  factory City.fromJson(Map<String, dynamic> json) {
    // Try to extract country from the name if it's in the format "City, Country"
    final name = json['Name'].toString();
    final parts = name.split(',');
    final cityName = parts[0].trim();
    final countryName = parts.length > 1 ? parts[1].trim() : '';

    return City(
      id: json['Id'].toString(),
      name: cityName,
      country: countryName,
    );
  }

  @override
  String toString() => '$name, $country';
}

class SearchCityController extends GetxController {

  final roomsCount = 1.obs;
  final adultsCount = 2.obs;
  final childrenCount = 0.obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  RxString searchText = ''.obs;

  var allCities = <City>[].obs;
  
  // Search related variables
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final isSearching = false.obs;
  final searchQuery = ''.obs;

  // Filter hotels by name
  List<Map<String, dynamic>> searchHotels(
      List<Map<String, dynamic>> hotels, String query) {
    if (query.isEmpty) return hotels;

    final queryLower = query.toLowerCase();
    return hotels
        .where((hotel) =>
            hotel['HotelName'].toString().toLowerCase().contains(queryLower))
        .toList(growable: false);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    update();
  }
  var filteredCities = <City>[].obs;
  var recentSearches = <City>[].obs;

  var selectedCity = Rxn<City>();
  var checkInDate = Rxn<DateTime>();
  var checkOutDate = Rxn<DateTime>();
  var hotelDetails = Rxn<Map<String, dynamic>>();

  // --- ADDED: State for the new Geo Locations feature ---
  var isGeoLoading = false.obs;
  final RxList<GeoLocation> geoLocations = <GeoLocation>[].obs;
  var SessionId = ''.obs;
  var hotelProviderSearchId;

  @override
  void onInit() {
    super.onInit();
    _fetchCities();
    ever(filteredCities, (_) {});
    recentSearches.assignAll([
      City(id: '1', name: 'Goa'),
      City(id: '2', name: 'Delhi'),
      City(id: '3', name: 'Manali'),
    ]);
  }

  Future<void> _fetchCities() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    try {
      final response = await http.post(
        Uri.parse(AppConfig.hotelCities),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['AcList'] == null) {
          _setError('Invalid response format: missing AcList');
          return;
        }
        final acList = responseData['AcList'] as List<dynamic>;
        final cities = acList
            .map((json) {
              try {
                return City.fromJson(Map<String, dynamic>.from(json));
              } catch (_) {
                return null;
              }
            })
            .where((city) => city != null)
            .cast<City>()
            .toList();
        allCities.assignAll(cities);
        filteredCities.assignAll(cities);
      } else {
        _setError('No hotel cities found (Status: ${response.statusCode})');
      }
    } catch (e) {
      _setError('Failed to load cities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  void filterCities(String query) {
    try {
      if (query.isEmpty) {
        filteredCities.assignAll(allCities);
      } else {
        final lower = query.toLowerCase();
        final filtered = allCities
            .where((city) => city.name.toLowerCase().contains(lower))
            .toList();
        filteredCities.assignAll(filtered);
      }
    } catch (_) {
      filteredCities.clear();
    }
  }

  void selectCity(City city) {
    selectedCity.value = city;
    _addToRecent(city);
  }

  void _addToRecent(City city) {
    recentSearches.removeWhere((c) => c.id == city.id);
    recentSearches.insert(0, city);
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }
  }

  Future<void> fetchHotelDetails({
    required String cityId,
    required String cityName,
    required DateTime checkIn,
    required DateTime checkOut,
    required int rooms,
    required int adults,
    required int children,
    int? pageNo,
    String? sessionId,
    Map<String, dynamic>? filter,
    Map<String, dynamic>? sort,
    List<Map<String, dynamic>>? roomsList, // <-- dynamic rooms
  }) async {
    // Set loading to true to show shimmer effect
    isLoading.value = true;

    // Add a 5-second delay before making the API call
    await Future.delayed(Duration(seconds: 5));

    try {
      final checkInStr = checkIn.toLocal().toString().split(' ')[0];
      final checkOutStr = checkOut.toLocal().toString().split(' ')[0];
      final List<Map<String, dynamic>> apiRooms = roomsList ??
          [
            {
              'RoomNo': rooms.toString(),
              'Adults': adults,
              'Children': children,
            }
          ];
      final requestData = {
        'cityId': cityId,
        'checkInDate': checkInStr,
        'checkOutDate': checkOutStr,
        'Rooms': apiRooms,
        'PageNo': pageNo ?? 1,
        'SessionID': sessionId,
        'Filter': filter,
        'Sort': sort ?? {"SortBy": "StarRating", "SortOrder": "Desc"},
      };
      print("==============> Fetching hotels list from API");
      print("City ID: $cityId");
      print("Check-in Date: $checkInStr");
      print("Check-out Date: $checkOutStr");
      print("Rooms: $apiRooms");
      print("Adults: $adults");
      print("Children: $children");
      print('Request Data: ${jsonEncode(requestData)}');

      final response = await http.post(
        Uri.parse(AppConfig.hotelsList),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );
      
      if (response.statusCode < 500 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        print("Response from hotels list API: $responseData");
        if (responseData['Hotels'] != null) {
          print(
              " *** Yeah , count for hotels is ${responseData['Hotels'].length}");
          hotelDetails.value = Map<String, dynamic>.from(responseData);
          hotelDetails.refresh();
          Get.to(() => HotelScreen(
                cityId: cityId,
                cityName: cityName,
                hotelDetails: Map<String, dynamic>.from(responseData),
              ));
        } else {
          _setError("No hotels found for the given criteria");
        }
      } else {
        _setError("No hotels found for the given criteria");
      }
    } catch (e) {
      print("Error fetching hotels list: $e");
      _setError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHotelDetailsWithPrice(
      {required String hotelId,
      required Map<String, dynamic> searchParams}) async {
    try {
      final payload = {
        'HotelId': hotelId,
        'CityId': searchParams['cityId'],
        'CheckInDate': searchParams['checkInDate'],
        'CheckOutDate': searchParams['checkOutDate'],
        'Rooms': [
          {
            'RoomNo': searchParams['Rooms'],
            'adults': searchParams['adults'],
            'children': searchParams['children']
          }
        ]
      };
      final response = await http.post(
        Uri.parse(AppConfig.hotelDetails),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Raw hotel details response: $data'); // Debug print

        // Validate the response structure
        if (data is Map && data['HotelDetail'] != null) {
          final hotelDetail = Map<String, dynamic>.from(data);
          hotelDetails.value = hotelDetail;

          // Add default values if missing
          if (!hotelDetail.containsKey('HotelName')) {
            hotelDetail['HotelName'] = 'No Name Available';
          }
          if (!hotelDetail.containsKey('StarRating')) {
            hotelDetail['StarRating'] = 0;
          }

          Get.to(() => HotelDetailScreen(
                hotelDetails: hotelDetail,
                hotelId: hotelId,
                searchParams: searchParams,
              ));
        } else {
          _setError('Invalid hotel details response from API');
          throw Exception('Invalid hotel details response');
        }
      } else {
        throw Exception(
            'API call failed with status code ${response.statusCode}');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<String>> fetchHotelImages(String hotelProviderSearchId) async {
    print('Fetching images for hotelProviderSearchId: $hotelProviderSearchId');
    try {
      final response = await http.post(
        Uri.parse(AppConfig.hotelImages),
        headers: {'Content-Type': 'application/json'},
        // The backend expects "HotelProviderSearchId" not "HotelId"
        body:
            jsonEncode({'HotelProviderSearchId': hotelProviderSearchId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Raw hotel images response: $data'); // <-- Debug print

        List<Map<String, String>> images = [];
        // The backend returns images in the "Gallery" key as a list of objects, each with a "Url" and "Name"
        if (data is Map && data['Gallery'] is List) {
          images = data['Gallery']
              .where((item) =>
                  item is Map &&
                  item['Url'] != null &&
                  item['Url'].toString().isNotEmpty)
              .map<Map<String, String>>((item) => {
                    'url': item['Url'].toString(),
                    'name': (item['Name'] ?? '').toString(),
                  })
              .toList();
        }
        Get.to(() => HotelImageScreen(
              imageList: images,
            ));
        print('Fetched images: $images');

        return images.map((img) => img['url'] ?? '').toList();
      } else {
        throw Exception('Failed to fetch hotel images: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- ADDED: New function to fetch Geo Locations ---
  Future<void> fetchGeoLocations(String sessionId) async {
    isGeoLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppConfig.hotelGeoList),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'SessionId': sessionId}),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final locationObjects = jsonDecode(response.body) as Map<String, dynamic>;
        // print('Fetched locations: $locationObjects');
        // 1. Get the raw list from the map
        final List<dynamic> rawList =
            locationObjects['GpsCoordinates'] as List? ?? [];

// 2. Convert the raw list into a List<Location> using your fromMap factory
        final List<Location> locations = rawList
            .map((item) => Location.fromMap(item as Map<String, dynamic>))
            .toList();

        // Navigate to the map screen with the parsed locations.
        Get.to(() => HotelMapScreen(locations: locations));
      } else {
        _setError(
            'Failed to fetch Geo Locations (Status: ${response.statusCode})');
      }
    } catch (e) {
      _setError('An error occurred while fetching Geo Locations: $e');
    } finally {
      isGeoLoading.value = false;
    }
  }

  // ADDED: A centralized method to handle the entire search logic.
  Future<void> performSearch(List<Map<String, dynamic>> roomGuestData) async {
    // 1. Validation Checks
    if (selectedCity.value == null || selectedCity.value!.id.isEmpty) {
      _showErrorSnackbar('Please select a city first');
      return;
    }
    if (checkInDate.value == null || checkOutDate.value == null) {
      _showErrorSnackbar('Please select check-in and check-out dates');
      return;
    }
    if (roomGuestData.isEmpty) {
      _showErrorSnackbar('Please select rooms and guests');
      return;
    }

    try {
      // 2. Set Loading State to true
      isLoading.value = true;

      // 3. Prepare API Payload
      final city = selectedCity.value!;
      final checkIn = checkInDate.value!;
      final checkOut = checkOutDate.value!;

      final List<Map<String, dynamic>> roomsList = roomGuestData.map((room) {
        return {
          "RoomNo": room["RoomNo"],
          "Adults": room["Adults"],
          "Children": room["Children"],
        };
      }).toList();

      final totalAdults =
          roomsList.fold<int>(0, (sum, r) => sum + (r["Adults"] as int? ?? 0));
      final totalChildren = roomsList.fold<int>(
          0, (sum, r) => sum + (r["Children"] as int? ?? 0));

      // 4. Call your existing fetch method
      // Assuming fetchHotelDetails handles navigation on success.
      await fetchHotelDetails(
        cityId: city.id,
        cityName: city.name,
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: roomsList.length,
        adults: totalAdults,
        children: totalChildren,
        roomsList: roomsList,
      );
    } catch (e) {
      debugPrint('Error during performSearch: $e');
      _showErrorSnackbar('Something went wrong. Please try again.');
    } finally {
      // 5. Set Loading State to false
      isLoading.value = false;
    }
  }

  // Helper method for showing styled snackbars
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Hotel Prebook API - Books the hotel before payment
  /// 
  /// This method builds the prebook request body and calls the backend API
  /// to reserve the hotel booking with traveller details.
  /// 
  /// Parameters:
  /// - [hotelDetails]: Map containing hotel information
  /// - [selectedRoom]: Map containing selected room details (must include UniqueReferencekey, ServiceIdentifer, OptionalToken, ServiceBookPrice)
  /// - [searchParams]: Map containing search parameters (checkInDate, checkOutDate, rooms, adults, children, etc.)
  /// - [primaryGuest]: Map containing primary guest details (name, email, mobile, etc.)
  /// - [selectedTravellers]: List of selected traveller maps from travellers list
  /// - [currency]: Currency code (default: "AED")
  /// 
  /// Returns: Map containing the API response
  Future<Map<String, dynamic>> hotelPrebook({
    required Map<String, dynamic> hotelDetails,
    required Map<String, dynamic> selectedRoom,
    required Map<String, dynamic> searchParams,
    required Map<String, dynamic> primaryGuest,
    required List<Map<String, dynamic>> selectedTravellers,
    String currency = 'AED',
  }) async {
    try {
      // Build the request body
      final requestBody = _buildPrebookRequestBody(
        hotelDetails: hotelDetails,
        selectedRoom: selectedRoom,
        searchParams: searchParams,
        primaryGuest: primaryGuest,
        selectedTravellers: selectedTravellers,
        currency: currency,
      );

      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.hotelPrebook}');
      print('      Method: POST');
      print('      Request Body: ${jsonEncode(requestBody)}');
      print('   🔄 Sending request to backend...');

      final response = await http.post(
        Uri.parse(AppConfig.hotelPrebook),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Prebook API failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in hotelPrebook: $e');
      rethrow;
    }
  }

  /// Builds the prebook request body from booking data
  Map<String, dynamic> _buildPrebookRequestBody({
    required Map<String, dynamic> hotelDetails,
    required Map<String, dynamic> selectedRoom,
    required Map<String, dynamic> searchParams,
    required Map<String, dynamic> primaryGuest,
    required List<Map<String, dynamic>> selectedTravellers,
    required String currency,
  }) {
    // Extract dates
    final checkInDate = searchParams['checkInDate'] ?? '';
    final checkOutDate = searchParams['checkOutDate'] ?? '';
    final checkInDateTime = checkInDate.isNotEmpty 
        ? DateTime.tryParse(checkInDate) ?? DateTime.now()
        : DateTime.now();
    
    // Extract room and price information
    final uniqueReferenceKey = selectedRoom['UniqueReferencekey'] ?? 
                               selectedRoom['uniqueReferencekey'] ?? 
                               '';
    final serviceIdentifier = selectedRoom['ServiceIdentifer'] ?? 
                              selectedRoom['serviceIdentifer'] ?? 
                              '';
    final optionalToken = selectedRoom['OptionalToken'] ?? 
                          selectedRoom['optionalToken'] ?? 
                          '';
    final serviceBookPrice = (selectedRoom['ServiceBookPrice'] ?? 
                              selectedRoom['serviceBookPrice'] ?? 
                              0.0) as num;
    
    // Extract hotel information
    final hotelDetail = hotelDetails['HotelDetail'] ?? hotelDetails;
    final hotelName = hotelDetail['HotelName'] ?? 'Hotel';
    final hotelImage = (hotelDetail['HotelImages'] is List && 
                       hotelDetail['HotelImages'].isNotEmpty)
        ? hotelDetail['HotelImages'][0]
        : selectedRoom['Image']?['ImageUrl'] ?? '';
    
    // Extract room details
    final roomName = selectedRoom['Name'] ?? selectedRoom['RoomName'] ?? 'Room';
    final mealCode = selectedRoom['MealCode'] ?? selectedRoom['mealCode'] ?? 'RO';
    final roomType = selectedRoom['RoomType'] ?? selectedRoom['roomType'] ?? '';
    
    // Extract guest counts
    final numRooms = int.tryParse(searchParams['rooms']?.toString() ?? '1') ?? 1;
    final numAdults = int.tryParse(searchParams['adults']?.toString() ?? '2') ?? 2;
    final numChildren = int.tryParse(searchParams['children']?.toString() ?? '0') ?? 0;
    
    // Build room details with passengers
    final roomDetails = _buildRoomDetails(
      numRooms: numRooms,
      numAdults: numAdults,
      numChildren: numChildren,
      primaryGuest: primaryGuest,
      selectedTravellers: selectedTravellers,
      roomName: roomName,
      roomType: roomType,
    );
    
    // Build pax detail string
    final totalAdults = numAdults;
    final totalChildren = numChildren;
    final paxDetail = '$totalAdults Adult${totalAdults != 1 ? 's' : ''} & $totalChildren Child${totalChildren != 1 ? 'ren' : ''} in $numRooms Room${numRooms != 1 ? 's' : ''}';
    
    // Build the request body (Credential will be added by backend)
    return {
      'ReservationName': _extractFullName(primaryGuest),
      'ReservationArrivalDate': '${checkInDateTime.toIso8601String().split('T')[0]}T00:00:00',
      'ReservationCurrency': currency,
      'ReservationAmount': serviceBookPrice.toDouble(),
      'ReservationClientReference': null,
      'ReservationRemarks': null,
      'BookingDetails': [
        {
          'SearchType': 'Hotel',
          'UniqueReferencekey': uniqueReferenceKey,
          'HotelServiceDetail': {
            'UniqueReferencekey': uniqueReferenceKey,
            'ProviderName': selectedRoom['ProviderName'] ?? 'HotelBeds',
            'ServiceIdentifer': serviceIdentifier,
            'ServiceBookPrice': serviceBookPrice.toDouble(),
            'OptionalToken': optionalToken,
            'ServiceCheckInTime': null,
            'Image': hotelImage,
            'HotelName': hotelName,
            'FromDate': checkInDate,
            'ToDate': checkOutDate,
            'ServiceName': '$roomName with $mealCode',
            'MealCode': mealCode,
            'PaxDetail': paxDetail,
            'BookCurrency': currency,
            'RoomDetails': roomDetails,
          }
        }
      ]
    };
  }

  /// Builds room details array with passenger information
  List<Map<String, dynamic>> _buildRoomDetails({
    required int numRooms,
    required int numAdults,
    required int numChildren,
    required Map<String, dynamic> primaryGuest,
    required List<Map<String, dynamic>> selectedTravellers,
    required String roomName,
    required String roomType,
  }) {
    final List<Map<String, dynamic>> roomDetailsList = [];
    
    // Calculate adults and children per room
    final adultsPerRoom = (numAdults / numRooms).ceil();
    final childrenPerRoom = (numChildren / numRooms).ceil();
    
    // Combine primary guest with selected travellers
    final allTravellers = <Map<String, dynamic>>[];
    
    // Add primary guest first (as lead passenger)
    allTravellers.add({
      ...primaryGuest,
      'isPrimary': true,
    });
    
    // Add selected travellers
    for (var traveller in selectedTravellers) {
      allTravellers.add({
        ...traveller,
        'isPrimary': false,
      });
    }
    
    // Distribute travellers across rooms
    int paxId = 1;
    int travellerIndex = 0;
    bool leadPaxAssigned = false;
    
    for (int roomId = 1; roomId <= numRooms; roomId++) {
      final roomPaxs = <Map<String, dynamic>>[];
      int adultsInRoom = 0;
      int childrenInRoom = 0;
      
      // Add adults to this room
      while (adultsInRoom < adultsPerRoom && travellerIndex < allTravellers.length) {
        final traveller = allTravellers[travellerIndex];
        final paxType = _getPaxType(traveller);
        
        if (paxType == 'A') {
          final isLeadPax = !leadPaxAssigned && roomId == 1;
          if (isLeadPax) leadPaxAssigned = true;
          
          roomPaxs.add(_buildPaxObject(
            traveller: traveller,
            paxId: paxId++,
            roomId: roomId,
            isLeadPax: isLeadPax,
          ));
          adultsInRoom++;
        }
        travellerIndex++;
      }
      
      // Add children to this room
      while (childrenInRoom < childrenPerRoom && travellerIndex < allTravellers.length) {
        final traveller = allTravellers[travellerIndex];
        final paxType = _getPaxType(traveller);
        
        if (paxType == 'C') {
          roomPaxs.add(_buildPaxObject(
            traveller: traveller,
            paxId: paxId++,
            roomId: roomId,
            isLeadPax: false,
          ));
          childrenInRoom++;
        }
        travellerIndex++;
      }
      
      // If we still need more adults/children, use remaining travellers
      while ((adultsInRoom < adultsPerRoom || childrenInRoom < childrenPerRoom) && 
             travellerIndex < allTravellers.length) {
        final traveller = allTravellers[travellerIndex];
        final paxType = _getPaxType(traveller);
        
        if (paxType == 'A' && adultsInRoom < adultsPerRoom) {
          roomPaxs.add(_buildPaxObject(
            traveller: traveller,
            paxId: paxId++,
            roomId: roomId,
            isLeadPax: false,
          ));
          adultsInRoom++;
        } else if (paxType == 'C' && childrenInRoom < childrenPerRoom) {
          roomPaxs.add(_buildPaxObject(
            traveller: traveller,
            paxId: paxId++,
            roomId: roomId,
            isLeadPax: false,
          ));
          childrenInRoom++;
        }
        travellerIndex++;
      }
      
      roomDetailsList.add({
        'RoomId': roomId,
        'Adults': adultsInRoom,
        if (childrenInRoom > 0) 'Children': childrenInRoom,
        'RoomName': roomName,
        'RoomType': roomType,
        'Paxs': roomPaxs,
        'ExtraBed': 0,
      });
    }
    
    return roomDetailsList;
  }

  /// Builds a passenger (Pax) object from traveller data
  Map<String, dynamic> _buildPaxObject({
    required Map<String, dynamic> traveller,
    required int paxId,
    required int roomId,
    required bool isLeadPax,
  }) {
    // Extract name components
    final fullName = _extractFullName(traveller);
    final nameParts = _splitName(fullName);
    final forename = nameParts['first'] ?? '';
    final midname = nameParts['middle'] ?? '';
    final surname = nameParts['last'] ?? '';
    
    // Extract other details
    final title = traveller['title'] ?? traveller['Title'] ?? 'Mr';
    final paxType = _getPaxType(traveller);
    final age = _getAge(traveller);
    final dob = _getDOB(traveller);
    final email = traveller['email'] ?? 
                  traveller['PaxEmail'] ?? 
                  traveller['contact_email'] ?? 
                  '';
    final mobile = traveller['mobile'] ?? 
                   traveller['PaxMobile'] ?? 
                   traveller['passengerMobileNumber'] ?? 
                   traveller['phone'] ?? 
                   '';
    final mobilePrefix = traveller['mobilePrefix'] ?? 
                         traveller['PaxMobilePrefix'] ?? 
                         traveller['mobile_prefix'] ?? 
                         '+91';
    
    return {
      'LeadPax': isLeadPax,
      'PaxId': paxId,
      'Title': title,
      'Forename': forename,
      'Midname': midname.isNotEmpty ? midname : null,
      'Surname': surname,
      'PaxType': paxType,
      'Age': age.toString(),
      'DOB': dob,
      'AddPax': !isLeadPax,
      'PaxEmail': email,
      'PaxMobile': mobile,
      'PaxMobilePrefix': mobilePrefix,
      'PaxDocuments': {
        'Passport': {
          'Nationality': null,
          'NationalityCode': null,
          'PassportNumber': null,
          'IssuingCountry': null,
          'IssuingCountryCode': null,
          'DateOfIssue': null,
          'DateOfExpiry': null,
          'PassportUpload': null,
          'IssuingCity': null,
          'IssuingCityCode': null,
          'PassportFirstPageURL': null,
          'PassportLastPageURL': null,
        },
        'Pan': {
          'PanNumber': null,
          'PanUpload': null,
        }
      },
      'RoomID': roomId,
    };
  }

  /// Helper methods
  String _extractFullName(Map<String, dynamic> traveller) {
    if (traveller['name'] != null) return traveller['name'].toString();
    if (traveller['passengerName'] != null) return traveller['passengerName'].toString();
    if (traveller['firstname'] != null) return traveller['firstname'].toString();
    
    final firstName = traveller['firstName'] ?? traveller['Forename'] ?? '';
    final middleName = traveller['middleName'] ?? traveller['Midname'] ?? '';
    final lastName = traveller['lastName'] ?? traveller['Surname'] ?? '';
    
    return [firstName, middleName, lastName]
        .where((n) => n != null && n.toString().isNotEmpty)
        .join(' ')
        .trim();
  }

  Map<String, String> _splitName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return {'first': '', 'middle': '', 'last': ''};
    if (parts.length == 1) return {'first': parts[0], 'middle': '', 'last': ''};
    if (parts.length == 2) return {'first': parts[0], 'middle': '', 'last': parts[1]};
    
    return {
      'first': parts[0],
      'middle': parts.sublist(1, parts.length - 1).join(' '),
      'last': parts.last,
    };
  }

  String _getPaxType(Map<String, dynamic> traveller) {
    if (traveller['PaxType'] != null) {
      final type = traveller['PaxType'].toString().toUpperCase();
      return type == 'C' ? 'C' : 'A';
    }
    if (traveller['paxType'] != null) {
      final type = traveller['paxType'].toString().toUpperCase();
      return type == 'C' ? 'C' : 'A';
    }
    
    // Determine from age
    final age = _getAge(traveller);
    return age < 18 ? 'C' : 'A';
  }

  int _getAge(Map<String, dynamic> traveller) {
    if (traveller['age'] != null) {
      final age = traveller['age'];
      if (age is int) return age;
      if (age is String) return int.tryParse(age) ?? 0;
    }
    if (traveller['Age'] != null) {
      final age = traveller['Age'];
      if (age is int) return age;
      if (age is String) return int.tryParse(age) ?? 0;
    }
    if (traveller['passengerAge'] != null) {
      final age = traveller['passengerAge'];
      if (age is int) return age;
      if (age is String) return int.tryParse(age) ?? 0;
    }
    
    // Calculate from DOB if available
    final dob = _getDOB(traveller);
    if (dob != null) {
      try {
        final dobDate = DateTime.parse(dob);
        final now = DateTime.now();
        final age = now.year - dobDate.year;
        if (now.month < dobDate.month || 
            (now.month == dobDate.month && now.day < dobDate.day)) {
          return age - 1;
        }
        return age;
      } catch (e) {
        return 0;
      }
    }
    
    return 0;
  }

  String? _getDOB(Map<String, dynamic> traveller) {
    if (traveller['DOB'] != null) return traveller['DOB'].toString();
    if (traveller['dob'] != null) return traveller['dob'].toString();
    if (traveller['dateOfBirth'] != null) return traveller['dateOfBirth'].toString();
    return null;
  }

  /// Hotel Book Complete API - Confirms the booking after payment
  /// 
  /// This method builds the book complete request body and calls the backend API
  /// to confirm the hotel booking after successful payment.
  /// 
  /// Parameters:
  /// - [prebookResponse]: Response from hotelPrebook API containing ReservationId and BookingId
  /// - [hotelDetails]: Map containing hotel information
  /// - [selectedRoom]: Map containing selected room details
  /// - [searchParams]: Map containing search parameters
  /// - [primaryGuest]: Map containing primary guest details
  /// - [selectedTravellers]: List of selected traveller maps
  /// - [currency]: Currency code (default: "AED")
  /// 
  /// Returns: Map containing the API response
  Future<Map<String, dynamic>> hotelBookComplete({
    required Map<String, dynamic> prebookResponse,
    required Map<String, dynamic> hotelDetails,
    required Map<String, dynamic> selectedRoom,
    required Map<String, dynamic> searchParams,
    required Map<String, dynamic> primaryGuest,
    required List<Map<String, dynamic>> selectedTravellers,
    String currency = 'AED',
  }) async {
    try {
      // Log the full prebook response structure for debugging
      print('   🔍 Analyzing Prebook Response Structure:');
      print('      Response keys: ${prebookResponse.keys.toList()}');
      print('      Full response: ${jsonEncode(prebookResponse)}');
      
      // Extract ReservationId and BookingId from prebook response (try multiple variations)
      String reservationId = '';
      String bookingId = '';
      
      // Try different possible field names for ReservationId
      reservationId = prebookResponse['ReservationId']?.toString() ?? 
                     prebookResponse['reservationId']?.toString() ?? 
                     prebookResponse['ReservationID']?.toString() ??
                     prebookResponse['reservation_id']?.toString() ??
                     prebookResponse['reservationID']?.toString() ?? '';
      
      print('   🔍 ReservationId extraction:');
      print('      Found: ${reservationId.isNotEmpty ? "✅" : "❌"}');
      if (reservationId.isNotEmpty) {
        print('      Value: $reservationId');
      }
      
      // Try different possible structures for BookingDetails
      dynamic bookingDetails = prebookResponse['BookingDetails'] ?? 
                              prebookResponse['bookingDetails'] ?? 
                              prebookResponse['booking_details'] ??
                              prebookResponse['Booking_Details'];
      
      if (bookingDetails != null) {
        print('   🔍 BookingDetails found: ${bookingDetails.runtimeType}');
        
        if (bookingDetails is List && bookingDetails.isNotEmpty) {
          print('      BookingDetails is a List with ${bookingDetails.length} items');
          final firstBooking = bookingDetails[0];
          print('      First booking keys: ${firstBooking is Map ? firstBooking.keys.toList() : "Not a Map"}');
          
          if (firstBooking is Map) {
            // Try different possible field names for BookingId
            bookingId = firstBooking['BookingId']?.toString() ?? 
                       firstBooking['bookingId']?.toString() ?? 
                       firstBooking['BookingID']?.toString() ??
                       firstBooking['booking_id']?.toString() ??
                       firstBooking['bookingID']?.toString() ?? '';
          }
        } else if (bookingDetails is Map) {
          print('      BookingDetails is a Map');
          print('      BookingDetails keys: ${bookingDetails.keys.toList()}');
          bookingId = bookingDetails['BookingId']?.toString() ?? 
                     bookingDetails['bookingId']?.toString() ?? 
                     bookingDetails['BookingID']?.toString() ??
                     bookingDetails['booking_id']?.toString() ??
                     bookingDetails['bookingID']?.toString() ?? '';
        }
      } else {
        print('   ⚠️  BookingDetails not found in response');
        // Try to find BookingId directly in the response root
        print('   🔍 Trying to find BookingId in response root...');
        bookingId = prebookResponse['BookingId']?.toString() ?? 
                   prebookResponse['bookingId']?.toString() ?? 
                   prebookResponse['BookingID']?.toString() ??
                   prebookResponse['booking_id']?.toString() ??
                   prebookResponse['bookingID']?.toString() ?? '';
        
        if (bookingId.isNotEmpty) {
          print('      ✅ Found BookingId in response root: $bookingId');
        } else {
          print('      ❌ BookingId not found in response root either');
        }
      }
      
      print('   🔍 BookingId extraction:');
      print('      Found: ${bookingId.isNotEmpty ? "✅" : "❌"}');
      if (bookingId.isNotEmpty) {
        print('      Value: $bookingId');
      }

      // Check if ReservationId is present (required)
      if (reservationId.isEmpty) {
        print('   ❌ ERROR: Missing ReservationId');
        print('   💡 Please check the prebook API response structure');
        throw Exception('Missing ReservationId from prebook response');
      }

      // BookingId might not be in prebook response - it might come from book complete response
      // If BookingId is missing, we'll use a placeholder or generate one
      if (bookingId.isEmpty) {
        print('   ⚠️  WARNING: BookingId not found in prebook response');
        print('   💡 BookingId might be generated by backend or come from book complete response');
        print('   🔄 Using ReservationId as BookingId placeholder (backend should handle this)');
        // Use reservationId as a fallback - backend might generate BookingId
        bookingId = reservationId;
      }

      // Build the request body
      final requestBody = _buildBookCompleteRequestBody(
        reservationId: reservationId,
        bookingId: bookingId,
        hotelDetails: hotelDetails,
        selectedRoom: selectedRoom,
        searchParams: searchParams,
        primaryGuest: primaryGuest,
        selectedTravellers: selectedTravellers,
        currency: currency,
      );

      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.hotelBooked}');
      print('      Method: POST');
      print('      ReservationId: $reservationId');
      print('      BookingId: $bookingId');
      print('      Request Body: ${jsonEncode(requestBody)}');
      print('   🔄 Sending request to backend...');

      final response = await http.post(
        Uri.parse(AppConfig.hotelBooked),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Book Complete API failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in hotelBookComplete: $e');
      rethrow;
    }
  }

  /// Builds the book complete request body from booking data
  Map<String, dynamic> _buildBookCompleteRequestBody({
    required String reservationId,
    required String bookingId,
    required Map<String, dynamic> hotelDetails,
    required Map<String, dynamic> selectedRoom,
    required Map<String, dynamic> searchParams,
    required Map<String, dynamic> primaryGuest,
    required List<Map<String, dynamic>> selectedTravellers,
    required String currency,
  }) {
    // Extract dates
    final checkInDate = searchParams['checkInDate'] ?? '';
    final checkOutDate = searchParams['checkOutDate'] ?? '';
    final checkInDateTime = checkInDate.isNotEmpty 
        ? DateTime.tryParse(checkInDate) ?? DateTime.now()
        : DateTime.now();
    
    // Extract room and price information
    final uniqueReferenceKey = selectedRoom['UniqueReferencekey'] ?? 
                               selectedRoom['uniqueReferencekey'] ?? 
                               '';
    final serviceIdentifier = selectedRoom['ServiceIdentifer'] ?? 
                              selectedRoom['serviceIdentifer'] ?? 
                              '';
    final optionalToken = selectedRoom['OptionalToken'] ?? 
                          selectedRoom['optionalToken'] ?? 
                          '';
    final serviceBookPrice = (selectedRoom['ServiceBookPrice'] ?? 
                              selectedRoom['serviceBookPrice'] ?? 
                              0.0) as num;
    
    // Extract hotel information
    final hotelDetail = hotelDetails['HotelDetail'] ?? hotelDetails;
    final hotelName = hotelDetail['HotelName'] ?? 'Hotel';
    final hotelImage = (hotelDetail['HotelImages'] is List && 
                       hotelDetail['HotelImages'].isNotEmpty)
        ? hotelDetail['HotelImages'][0]
        : selectedRoom['Image']?['ImageUrl'] ?? '';
    
    // Extract room details
    final roomName = selectedRoom['Name'] ?? selectedRoom['RoomName'] ?? 'Room';
    final mealCode = selectedRoom['MealCode'] ?? selectedRoom['mealCode'] ?? 'RO';
    final roomType = selectedRoom['RoomType'] ?? selectedRoom['roomType'] ?? '';
    
    // Extract guest counts
    final numRooms = int.tryParse(searchParams['rooms']?.toString() ?? '1') ?? 1;
    final numAdults = int.tryParse(searchParams['adults']?.toString() ?? '2') ?? 2;
    final numChildren = int.tryParse(searchParams['children']?.toString() ?? '0') ?? 0;
    
    // Build room details with passengers
    final roomDetails = _buildRoomDetails(
      numRooms: numRooms,
      numAdults: numAdults,
      numChildren: numChildren,
      primaryGuest: primaryGuest,
      selectedTravellers: selectedTravellers,
      roomName: roomName,
      roomType: roomType,
    );
    
    // Build pax detail string
    final totalAdults = numAdults;
    final totalChildren = numChildren;
    final paxDetail = '$totalAdults Adult${totalAdults != 1 ? 's' : ''} & $totalChildren Child${totalChildren != 1 ? 'ren' : ''} in $numRooms Room${numRooms != 1 ? 's' : ''}';
    
    // Build the request body (Credential will be added by backend)
    return {
      'ReservationId': reservationId,
      'ReservationName': _extractFullName(primaryGuest),
      'ReservationArrivalDate': '${checkInDateTime.toIso8601String().split('T')[0]}T00:00:00',
      'ReservationCurrency': currency,
      'ReservationAmount': serviceBookPrice.toDouble(),
      'ReservationClientReference': null,
      'ReservationRemarks': null,
      'BookingDetails': [
        {
          'BookingId': bookingId,
          'SearchType': 'Hotel',
          'UniqueReferencekey': uniqueReferenceKey,
          'HotelServiceDetail': {
            'UniqueReferencekey': uniqueReferenceKey,
            'ProviderName': selectedRoom['ProviderName'] ?? 'HotelBeds',
            'ServiceIdentifer': serviceIdentifier,
            'ServiceBookPrice': serviceBookPrice.toDouble(),
            'OptionalToken': optionalToken,
            'ServiceCheckInTime': null,
            'Image': hotelImage,
            'HotelName': hotelName,
            'FromDate': checkInDate,
            'ToDate': checkOutDate,
            'ServiceName': '$roomName with $mealCode',
            'MealCode': mealCode,
            'PaxDetail': paxDetail,
            'BookCurrency': currency,
            'RoomDetails': roomDetails,
          }
        }
      ]
    };
  }

  /// Save hotel booking to database
  /// 
  /// This method saves the completed booking information to the database
  /// 
  /// Parameters:
  /// - [bookingData]: Map containing all booking information to save
  /// 
  /// Returns: Map containing the save response
  Future<Map<String, dynamic>> saveHotelBookingToDatabase({
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      print('   💾 Preparing booking data for database...');
      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.saveHotelBooking}');
      print('      Method: POST');
      print('   📋 Booking Data Being Sent:');
      print('      ${jsonEncode(bookingData)}');
      print('   🔄 Sending request to backend...');

      final response = await http.post(
        Uri.parse(AppConfig.saveHotelBooking),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          print('   ✅ Booking saved to database successfully');
          print('      Database ID: ${responseData['bookingId']}');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to save booking');
        }
      } else {
        throw Exception('Save booking API failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('   ❌ Error saving booking to database: $e');
      rethrow;
    }
  }

  /// Get all hotel bookings
  /// 
  /// Returns: List of all hotel bookings
  Future<List<Map<String, dynamic>>> getAllHotelBookings() async {
    try {
      print('   📋 Fetching all hotel bookings...');
      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.getAllHotelBookings}');
      print('      Method: GET');

      final response = await http.get(
        Uri.parse(AppConfig.getAllHotelBookings),
        headers: {'Content-Type': 'application/json'},
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData is List) {
          return responseData.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (responseData is Map) {
          // Handle {"success":true,"data":[...]} structure
          if (responseData['data'] != null && responseData['data'] is List) {
            final bookings = responseData['data'] as List;
            return bookings.map((item) => Map<String, dynamic>.from(item)).toList();
          } else if (responseData['bookings'] != null && responseData['bookings'] is List) {
            final bookings = responseData['bookings'] as List;
            return bookings.map((item) => Map<String, dynamic>.from(item)).toList();
          } else {
            return [];
          }
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('   ❌ Error fetching all hotel bookings: $e');
      rethrow;
    }
  }

  /// Get hotel bookings for a specific user
  /// 
  /// Parameters:
  /// - [userId]: The user ID to fetch bookings for
  /// 
  /// Returns: List of hotel bookings for the user
  Future<List<Map<String, dynamic>>> getUserHotelBookings(int userId) async {
    try {
      print('   📋 Fetching hotel bookings for user: $userId');
      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.getUserHotelBookings(userId)}');
      print('      Method: GET');

      final response = await http.get(
        Uri.parse(AppConfig.getUserHotelBookings(userId)),
        headers: {'Content-Type': 'application/json'},
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData is List) {
          return responseData.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (responseData is Map) {
          // Handle {"success":true,"data":[...]} structure
          if (responseData['data'] != null && responseData['data'] is List) {
            final bookings = responseData['data'] as List;
            return bookings.map((item) => Map<String, dynamic>.from(item)).toList();
          } else if (responseData['bookings'] != null && responseData['bookings'] is List) {
            final bookings = responseData['bookings'] as List;
            return bookings.map((item) => Map<String, dynamic>.from(item)).toList();
          } else {
            return [];
          }
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch user bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('   ❌ Error fetching user hotel bookings: $e');
      rethrow;
    }
  }

  /// Get a specific hotel booking by ID
  /// 
  /// Parameters:
  /// - [bookingId]: The booking ID to fetch
  /// 
  /// Returns: Map containing the booking details
  Future<Map<String, dynamic>> getHotelBookingById(String bookingId) async {
    try {
      print('   📋 Fetching hotel booking: $bookingId');
      print('   📤 API Request Details:');
      print('      Endpoint: ${AppConfig.getHotelBookingById(bookingId)}');
      print('      Method: GET');

      final response = await http.get(
        Uri.parse(AppConfig.getHotelBookingById(bookingId)),
        headers: {'Content-Type': 'application/json'},
      );

      print('   📥 API Response Received:');
      print('      Status Code: ${response.statusCode}');
      print('      Response: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      print('   ❌ Error fetching hotel booking by ID: $e');
      rethrow;
    }
  }
}
