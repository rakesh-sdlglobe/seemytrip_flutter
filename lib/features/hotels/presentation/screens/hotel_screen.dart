import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../shared/constants/images.dart';
import '../controllers/hotel_controller.dart';
import '../controllers/hotel_filter_controller.dart';
import '../widgets/hotel_list_card.dart';

class HotelScreen extends GetView<SearchCityController> {

  HotelScreen({
    required this.cityId, required this.cityName, required this.hotelDetails, Key? key,
  }) : super(key: key);
  final String cityId;
  final String cityName;
  final Map<String, dynamic> hotelDetails;

  @override
  Widget build(BuildContext context) {
    final SearchCityController searchCtrl = Get.put(SearchCityController());
    final HotelFilterController filterCtrl = Get.put(HotelFilterController());
    final List<Map<String, dynamic>> hotels =
        List<Map<String, dynamic>>.from(hotelDetails['Hotels'] ?? <dynamic>[]);
    final DateTime? checkInDate = searchCtrl.checkInDate.value;
    final DateTime? checkOutDate = searchCtrl.checkOutDate.value;
    final sessionId = hotelDetails['SessionId'];
    print('sessionId: $sessionId');
    final String dateRange = checkInDate != null && checkOutDate != null
        ? '${checkInDate.day} ${_getMonthName(checkInDate.month)} - ${checkOutDate.day} ${_getMonthName(checkOutDate.month)}'
        : '';
    final int roomCount = searchCtrl.roomsCount.value;
    final int adultCount = searchCtrl.adultsCount.value;
    final int childCount = searchCtrl.childrenCount.value;
    final String guestInfo =
        "$roomCount Room, $adultCount Adults${childCount > 0 ? ', $childCount Children' : ''}";

    // Always initialize filter on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (filterCtrl.filteredHotels.isEmpty) {
        filterCtrl.initHotels(hotels);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _HotelScreenHeader(
                cityName: cityName,
                cityId: cityId,
                searchCtrl: searchCtrl,
                sessionId: sessionId,
                dateRange: dateRange,
                guestInfo: guestInfo,
              ),
              // --- Search Bar ---
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchCtrl.searchController,
                    onChanged: (query) {
                      searchCtrl.searchQuery.value = query;
                      filterCtrl.applySearch(query);
                    },
                    onSubmitted: (query) {
                      searchCtrl.searchQuery.value = query;
                      filterCtrl.applySearch(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search hotels...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.textHint),
                      border: InputBorder.none,
                      suffixIcon: Obx(() {
                        if (searchCtrl.searchQuery.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary),
                            onPressed: () {
                              searchCtrl.searchController.clear();
                              searchCtrl.searchQuery.value = '';
                              filterCtrl.applySearch('');
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              // --- Hotel Filter Section (Train style) ---
              Container(
                color: AppColors.surface,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _HotelFilterChip(
                            label: 'All',
                            icon: Icons.list,
                            selected: filterCtrl.selectedFilter.value == 'all',
                            onTap: () => filterCtrl.applyFilter('all', hotels),
                          ),
                          _HotelFilterChip(
                            label: 'Low Price',
                            icon: Icons.arrow_downward,
                            selected:
                                filterCtrl.selectedFilter.value == 'low_price',
                            onTap: () =>
                                filterCtrl.applyFilter('low_price', hotels),
                          ),
                          _HotelFilterChip(
                            label: 'High Price',
                            icon: Icons.arrow_upward,
                            selected:
                                filterCtrl.selectedFilter.value == 'high_price',
                            onTap: () =>
                                filterCtrl.applyFilter('high_price', hotels),
                          ),
                          _HotelFilterChip(
                            label: 'Star Rating',
                            icon: Icons.star,
                            selected: filterCtrl.selectedFilter.value ==
                                'star_rating',
                            onTap: () =>
                                filterCtrl.applyFilter('star_rating', hotels),
                          ),
                          // Add more filter chips as needed
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                  ),
                                  builder: (BuildContext ctx) => _HotelFilterBottomSheet(
                                    filterCtrl: filterCtrl,
                                    hotels: hotels,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.filter_alt,
                                    color: AppColors.primary, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  if (searchCtrl.isLoading.value) {
                    // Show circular loader while loading
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  }

                  final RxList<Map<String, dynamic>> filteredHotels = filterCtrl.filteredHotels;
                  // If filter applied and no hotels, show "No hotels found for selected filters"
                  if (filteredHotels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.hotel_outlined,
                              size: 48, color: AppColors.textSecondary),
                          SizedBox(height: 16),
                          Text(
                            filterCtrl.selectedFilter.value != 'all' &&
                                    hotels.isNotEmpty
                                ? 'No hotels found for selected filters'
                                : 'No hotels found for these dates',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredHotels.length,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> hotel = filteredHotels[index];
                      return HotelListCard(
                        hotel: hotel,
                        cityName: cityName,
                        cityId: cityId,
                        searchCtrl: searchCtrl,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          // Loading overlay is now handled by the shimmer effect in the list
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

// --- Header Widget ---
class _HotelScreenHeader extends StatelessWidget {

  const _HotelScreenHeader({
    required this.cityName, required this.cityId, required this.dateRange, required this.guestInfo, required this.searchCtrl, required this.sessionId, Key? key,
  }) : super(key: key);
  final String cityName;
  final String cityId;
  final String dateRange;
  final String guestInfo;
  final SearchCityController searchCtrl;
  final String sessionId;

  @override
  Widget build(BuildContext context) => Container(
      height: 155,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(hotelAndHomeStayTopImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  horizontalTitleGap: -5,
                  leading: InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.textSecondary, size: 20),
                  ),
                  title: CommonTextWidget.PoppinsMedium(
                    text: cityName,
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  subtitle: CommonTextWidget.PoppinsRegular(
                    text: '$dateRange, $guestInfo',
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  trailing: InkWell(
                    onTap: () {
                      // Navigate back to the search screen
                      Get.back();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SvgPicture.asset(draw),
                        const SizedBox(height: 10),
                        CommonTextWidget.PoppinsMedium(
                          text: 'Edit',
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () {
                  searchCtrl.fetchGeoLocations(sessionId);
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.location_on, color: AppColors.primary),
                        CommonTextWidget.PoppinsMedium(
                          text: 'Map',
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

// --- Filter Chip Widget ---
class _HotelFilterChip extends StatelessWidget {

  const _HotelFilterChip({
    required this.label, required this.icon, required this.selected, required this.onTap, Key? key,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: 1,
            ),
            boxShadow: selected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ]
                : <BoxShadow>[],
          ),
          child: Row(
            children: <Widget>[
              Icon(icon,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  size: 17),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (selected)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.check, color: AppColors.primary, size: 15),
                ),
            ],
          ),
        ),
      ),
    );
}

// --- Bottom Sheet for More Filters ---
class _HotelFilterBottomSheet extends StatefulWidget {

  const _HotelFilterBottomSheet({
    required this.filterCtrl, required this.hotels, Key? key,
  }) : super(key: key);
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  @override
  State<_HotelFilterBottomSheet> createState() =>
      _HotelFilterBottomSheetState();
}

class _HotelFilterBottomSheetState extends State<_HotelFilterBottomSheet> {
  RangeValues priceRange = RangeValues(0, 10000);
  int selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    // Calculate min/max price from hotels list
    final List<double> prices = widget.hotels
        .map((Map<String, dynamic> h) => (h['HotelServices'] != null &&
                h['HotelServices'].isNotEmpty &&
                h['HotelServices'][0]['ServicePrice'] != null)
            ? double.tryParse(h['HotelServices'][0]['ServicePrice']
                    .toString()
                    .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0
            : double.tryParse(h['MinPrice']?.toString() ?? '0') ?? 0)
        .toList();
    final num minPrice =
        prices.isNotEmpty ? prices.reduce((double a, double b) => a < b ? a : b) : 0;
    final num maxPrice =
        prices.isNotEmpty ? prices.reduce((double a, double b) => a > b ? a : b) : 10000;

    // Set initial range only once
    if (priceRange.start == 0 &&
        priceRange.end == 10000 &&
        minPrice != maxPrice) {
      priceRange = RangeValues(minPrice as double, maxPrice as double);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('All Filters',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 18),
              // Price Range Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Price Range (₹${priceRange.start.toInt()} - ₹${priceRange.end.toInt()})',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              RangeSlider(
                min: minPrice.toDouble(),
                max: maxPrice == minPrice
                    ? minPrice.toDouble() + 1
                    : maxPrice.toDouble(),
                values: priceRange,
                divisions: maxPrice > minPrice ? 20 : 1,
                labels: RangeLabels(
                  '₹${priceRange.start.toInt()}',
                  '₹${priceRange.end.toInt()}',
                ),
                onChanged: (RangeValues v) {
                  setState(() {
                    priceRange = v;
                  });
                },
              ),
              SizedBox(height: 18),
              // Star Rating Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Star Rating',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (int i) {
                  final int star = i + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStar = selectedStar == star ? 0 : star;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 180),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: selectedStar >= star
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedStar >= star
                              ? AppColors.primary
                              : AppColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.star,
                        color: selectedStar >= star
                            ? Colors.amber
                            : AppColors.divider,
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 28),
              // Add more filter widgets here (e.g. amenities, meal plan, cancellation, etc.)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply price and star rating filter
                    final List<Map<String, dynamic>> filtered = widget.hotels.where((Map<String, dynamic> hotel) {
                      // Price filter
                      final double price = (hotel['HotelServices'] != null &&
                              hotel['HotelServices'].isNotEmpty &&
                              hotel['HotelServices'][0]['ServicePrice'] != null)
                          ? double.tryParse(hotel['HotelServices'][0]
                                      ['ServicePrice']
                                  .toString()
                                  .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                              0
                          : double.tryParse(
                                  hotel['MinPrice']?.toString() ?? '0') ??
                              0;
                      final bool priceMatch =
                          price >= priceRange.start && price <= priceRange.end;

                      // Star rating filter
                      final double star = double.tryParse(
                              hotel['StarRating']?.toString() ?? '0') ??
                          0;
                      final bool starMatch =
                          selectedStar == 0 || star.floor() == selectedStar;

                      return priceMatch && starMatch;
                    }).toList();

                    widget.filterCtrl.filteredHotels.assignAll(filtered);
                    widget.filterCtrl.selectedFilter.value = 'custom';
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
