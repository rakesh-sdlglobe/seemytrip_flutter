import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_image_screen.dart';
import 'dart:convert';

class City {
  final String id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['Id'].toString(),
      name: json['Name'].toString(),
    );
  }

  @override
  String toString() => name;
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
  var filteredCities = <City>[].obs;
  var recentSearches = <City>[].obs;

  var selectedCity = Rxn<City>();
  var checkInDate = Rxn<DateTime>();
  var checkOutDate = Rxn<DateTime>();
  var hotelDetails = Rxn<Map<String, dynamic>>();

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
        'http://192.168.137.102:3002/api/hotels/getHotelCities',
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
        final cities = acList.map((json) {
          try {
            return City.fromJson(Map<String, dynamic>.from(json));
          } catch (_) {
            return null;
          }
        }).where((city) => city != null).cast<City>().toList();
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
        final filtered = allCities.where(
          (city) => city.name.toLowerCase().contains(lower)
        ).toList();
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
  }) async {
    try {
      final checkInStr = checkIn.toLocal().toString().split(' ')[0];
      final checkOutStr = checkOut.toLocal().toString().split(' ')[0];
      final requestData = {
        'cityId': int.parse(cityId),
        'checkInDate': checkInStr,
        'checkOutDate': checkOutStr,
        'Rooms': [
          {
            'RoomNo': '1',
            'Adults': adults.toString(),
            'Children': children.toString()
          }
        ]
      };
      final response = await dio.post(
        'http://192.168.137.102:3002/api/hotels/getHotelsList',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
        data: requestData,
      );
      if (response.statusCode == 200 && response.data != null) {
        hotelDetails.value = Map<String, dynamic>.from(response.data);
        Get.to(() => HotelScreen(
          cityId: cityId,
          cityName: cityName,
          hotelDetails: response.data,
        ));
      } else {
        final errorMsg = response.data is Map ?
          response.data['error'] ?? 'Unknown error' :
          'Failed to fetch hotels';
        _setError(errorMsg);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHotelDetailsWithPrice({
    required String hotelId,
    required Map<String, dynamic> searchParams
  }) async {
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
        Uri.parse('http://192.168.137.102:3002/api/hotels/getHoteldetails'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        hotelDetails.value = Map<String, dynamic>.from(data);
        Get.to(() => HotelDetailScreen(hotelDetails: data,  
          hotelId: hotelId,
          searchParams: searchParams,
        ));
        print('Hotel Details: $data');
      } else {
        throw Exception('API call failed with status code ${response.statusCode}');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<String>> fetchHotelImages(String hotelProviderSearchId) async {
    print('Fetching images for hotelProviderSearchId: $hotelProviderSearchId');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.102:3002/api/hotels/getHotelImages'),
        headers: {'Content-Type': 'application/json'},
        // The backend expects "HotelProviderSearchId" not "HotelId"
        body: jsonEncode({'HotelProviderSearchId': hotelProviderSearchId ?? ''}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Raw hotel images response: $data'); // <-- Debug print

        List<Map<String, String>> images = [];
        // The backend returns images in the "Gallery" key as a list of objects, each with a "Url" and "Name"
        if (data is Map && data['Gallery'] is List) {
          images = data['Gallery']
              .where((item) => item is Map && item['Url'] != null && item['Url'].toString().isNotEmpty)
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


  
}