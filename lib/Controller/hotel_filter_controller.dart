import 'package:get/get.dart';

class HotelFilterController extends GetxController {
  var selectedFilter = 'all'.obs;
  var filteredHotels = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> _allHotels = [];

  void initHotels(List<Map<String, dynamic>> hotels) {
    _allHotels = List<Map<String, dynamic>>.from(hotels);
    filteredHotels.assignAll(_allHotels);
    selectedFilter.value = 'all';
  }

  void applyFilter(String filterType, List<Map<String, dynamic>> hotels) {
    selectedFilter.value = filterType;
    List<Map<String, dynamic>> baseList = _allHotels.isNotEmpty ? _allHotels : hotels;
    if (filterType == '' || filterType == 'all') {
      filteredHotels.assignAll(baseList);
      return;
    }
    List<Map<String, dynamic>> filtered = [];
    switch (filterType) {
      case 'low_price':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) {
            final aPrice = _getHotelPrice(a);
            final bPrice = _getHotelPrice(b);
            return aPrice.compareTo(bPrice);
          });
        break;
      case 'high_price':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) {
            final aPrice = _getHotelPrice(a);
            final bPrice = _getHotelPrice(b);
            return bPrice.compareTo(aPrice);
          });
        break;
      case 'star_rating':
        filtered = List<Map<String, dynamic>>.from(baseList)
          ..sort((a, b) {
            final aRating = double.tryParse(a['StarRating']?.toString() ?? '0') ?? 0;
            final bRating = double.tryParse(b['StarRating']?.toString() ?? '0') ?? 0;
            return bRating.compareTo(aRating);
          });
        break;
      // Add more filter cases as needed
      default:
        filtered = baseList;
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
}
