import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:seemytrip/Models/hotel_geolocation_model.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_map_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_image_screen.dart';
import 'dart:convert';

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
  final dio = Dio();

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
      final response = await dio.post(
        'http://192.168.137.150:3002/api/hotels/getHotelCities',
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['AcList'] == null) {
          _setError('Invalid response format: missing AcList');
          return;
        }
        final acList = response.data['AcList'] as List<dynamic>;
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

      final response = await dio.post(
        'http://192.168.137.150:3002/api/hotels/getHotelsList',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
        data: requestData,
      );
      print("Response from hotels list API: ${response.data}");
      if (response.data != null && response.data['Hotels'] != null) {
        print(
            " *** Yeah , count for hotels is ${response.data['Hotels'].length}");
        hotelDetails.value = Map<String, dynamic>.from(response.data);
        hotelDetails.refresh();
        Get.to(() => HotelScreen(
              cityId: cityId,
              cityName: cityName,
              hotelDetails: Map<String, dynamic>.from(response.data),
            ));
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
        Uri.parse('http://192.168.137.150:3002/api/hotels/getHoteldetails'),
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
        Uri.parse('http://192.168.137.150:3002/api/hotels/getHotelImages'),
        headers: {'Content-Type': 'application/json'},
        // The backend expects "HotelProviderSearchId" not "HotelId"
        body:
            jsonEncode({'HotelProviderSearchId': hotelProviderSearchId ?? ''}),
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
              imageList: images ?? <Map<String, String>>[],
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
      final response = await dio.post(
        'http://192.168.137.150:3002/api/hotels/getGeoList',
        data: {'SessionId': sessionId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final locationObjects = response.data;
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
}
