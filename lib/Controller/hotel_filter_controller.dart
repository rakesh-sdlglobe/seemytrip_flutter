import 'package:get/get.dart';

class HotelFilterController extends GetxController {
  var selectedFilter = 'all'.obs;
  var filteredHotels = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> _allHotels = [];
  String _currentSearchQuery = '';

  void initHotels(List<Map<String, dynamic>> hotels) {
    _allHotels = List<Map<String, dynamic>>.from(hotels);
    filteredHotels.assignAll(_allHotels);
    selectedFilter.value = 'all';
  }

  void applyFilter(String filterType, List<Map<String, dynamic>> hotels) {
    selectedFilter.value = filterType;
    
    // Always use _allHotels as the base list if available, otherwise use the provided hotels list
    List<Map<String, dynamic>> baseList = _allHotels.isNotEmpty ? _allHotels : hotels;
    
    // If no filter is selected or 'all' is selected, just show all hotels (with search applied if any)
    if (filterType == '' || filterType == 'all') {
      if (_currentSearchQuery.isEmpty) {
        filteredHotels.assignAll(baseList);
      } else {
        // Apply search if there's an active query
        applySearch(_currentSearchQuery);
      }
      return;
    }
    
    // Apply the selected filter
    List<Map<String, dynamic>> filtered = [];
    switch (filterType) {
      case 'low_price':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) => _getHotelPrice(a).compareTo(_getHotelPrice(b)));
        break;
      case 'high_price':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) => _getHotelPrice(b).compareTo(_getHotelPrice(a)));
        break;
      case 'star_rating':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) {
            final aRating = double.tryParse(a['StarRating']?.toString() ?? '0') ?? 0;
            final bRating = double.tryParse(b['StarRating']?.toString() ?? '0') ?? 0;
            return bRating.compareTo(aRating);
          });
        break;
      default:
        filtered = List<Map<String, dynamic>>.from(baseList);
    }
    
    // Apply search filter if there's an active search query
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final hotelName = hotel['HotelName']?.toString().toLowerCase() ?? '';
        return hotelName.contains(_currentSearchQuery);
      }).toList();
    }
    
    filteredHotels.assignAll(filtered);
  }

  int _getHotelPrice(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePrice'] != null) {
      return int.tryParse(hotel['HotelServices'][0]['ServicePrice'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
    return int.tryParse((hotel['MinPrice']?.toString() ?? '').replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
  
  // Apply search filter to the current hotel list
  void applySearch(String query) {
    _currentSearchQuery = query.trim().toLowerCase();
    if (_allHotels.isEmpty) return;
    
    List<Map<String, dynamic>> filtered = [];
    
    // Apply current filter first
    switch (selectedFilter.value) {
      case 'low_price':
        filtered = List<Map<String, dynamic>>.from(_allHotels)
          ..sort((a, b) => _getHotelPrice(a).compareTo(_getHotelPrice(b)));
        break;
      case 'high_price':
        filtered = List<Map<String, dynamic>>.from(_allHotels)
          ..sort((a, b) => _getHotelPrice(b).compareTo(_getHotelPrice(a)));
        break;
      case 'star_rating':
        filtered = List<Map<String, dynamic>>.from(_allHotels)
          ..sort((a, b) {
            final aRating = double.tryParse(a['StarRating']?.toString() ?? '0') ?? 0;
            final bRating = double.tryParse(b['StarRating']?.toString() ?? '0') ?? 0;
            return bRating.compareTo(aRating);
          });
        break;
      default:
        filtered = List<Map<String, dynamic>>.from(_allHotels);
    }
    
    // Then apply search filter
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final hotelName = hotel['HotelName']?.toString().toLowerCase() ?? '';
        return hotelName.contains(_currentSearchQuery);
      }).toList();
    }
    
    filteredHotels.assignAll(filtered);
  }
  
  // Clear search and reset filters
  void clearSearch() {
    _currentSearchQuery = '';
    // Reapply the current filter to show all hotels
    if (_allHotels.isNotEmpty) {
      filteredHotels.assignAll(_allHotels);
      applyFilter(selectedFilter.value, _allHotels);
    }
  }
}
