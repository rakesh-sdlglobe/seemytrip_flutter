import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/hotels/presentation/widgets/hotel_list_card.dart';
import 'package:seemytrip/features/hotels/presentation/controllers/hotel_filter_controller.dart';
import 'package:seemytrip/features/hotels/presentation/controllers/hotel_controller.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/theme/app_text_styles.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class HotelScreen extends GetView<SearchCityController> {
  final String cityId;
  final String cityName;
  final Map<String, dynamic> hotelDetails;

  HotelScreen({
    Key? key,
    required this.cityId,
    required this.cityName,
    required this.hotelDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchCityController searchCtrl = Get.put(SearchCityController());
    final HotelFilterController filterCtrl = Get.put(HotelFilterController());
    final hotels =
        List<Map<String, dynamic>>.from(hotelDetails['Hotels'] ?? []);
    final checkInDate = searchCtrl.checkInDate.value;
    final checkOutDate = searchCtrl.checkOutDate.value;
    final sessionId = hotelDetails['SessionId'];
    print("sessionId: $sessionId");
    final dateRange = checkInDate != null && checkOutDate != null
        ? "${checkInDate.day} ${_getMonthName(checkInDate.month)} - ${checkOutDate.day} ${_getMonthName(checkOutDate.month)}"
        : "";
    final roomCount = searchCtrl.roomsCount.value;
    final adultCount = searchCtrl.adultsCount.value;
    final childCount = searchCtrl.childrenCount.value;
    final guestInfo =
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
        children: [
          Column(
            children: [
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchCtrl.searchController,
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
                              searchCtrl.clearSearch();
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
                        children: [
                          _HotelFilterChip(
                            label: "All",
                            icon: Icons.list,
                            selected: filterCtrl.selectedFilter.value == 'all',
                            onTap: () => filterCtrl.applyFilter('all', hotels),
                          ),
                          _HotelFilterChip(
                            label: "Low Price",
                            icon: Icons.arrow_downward,
                            selected:
                                filterCtrl.selectedFilter.value == 'low_price',
                            onTap: () =>
                                filterCtrl.applyFilter('low_price', hotels),
                          ),
                          _HotelFilterChip(
                            label: "High Price",
                            icon: Icons.arrow_upward,
                            selected:
                                filterCtrl.selectedFilter.value == 'high_price',
                            onTap: () =>
                                filterCtrl.applyFilter('high_price', hotels),
                          ),
                          _HotelFilterChip(
                            label: "Star Rating",
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
                                  builder: (ctx) => _HotelFilterBottomSheet(
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

                  final filteredHotels = filterCtrl.filteredHotels;
                  // If filter applied and no hotels, show "No hotels found for selected filters"
                  if (filteredHotels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
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
    const months = [
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
  final String cityName;
  final String cityId;
  final String dateRange;
  final String guestInfo;
  final SearchCityController searchCtrl;
  final String sessionId;

  const _HotelScreenHeader({
    Key? key,
    required this.cityName,
    required this.cityId,
    required this.dateRange,
    required this.guestInfo,
    required this.searchCtrl,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          children: [
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
                    text: "$dateRange, $guestInfo",
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
                      children: [
                        SvgPicture.asset(draw),
                        const SizedBox(height: 10),
                        CommonTextWidget.PoppinsMedium(
                          text: "Edit",
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
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        CommonTextWidget.PoppinsMedium(
                          text: "Map",
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
}

// --- Filter Chip Widget ---
class _HotelFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _HotelFilterChip({
    Key? key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
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
}

// --- Bottom Sheet for More Filters ---
class _HotelFilterBottomSheet extends StatefulWidget {
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  const _HotelFilterBottomSheet({
    Key? key,
    required this.filterCtrl,
    required this.hotels,
  }) : super(key: key);

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
    final prices = widget.hotels
        .map((h) => (h['HotelServices'] != null &&
                h['HotelServices'].isNotEmpty &&
                h['HotelServices'][0]['ServicePrice'] != null)
            ? double.tryParse(h['HotelServices'][0]['ServicePrice']
                    .toString()
                    .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0
            : double.tryParse(h['MinPrice']?.toString() ?? '0') ?? 0)
        .toList();
    final minPrice =
        prices.isNotEmpty ? prices.reduce((a, b) => a < b ? a : b) : 0;
    final maxPrice =
        prices.isNotEmpty ? prices.reduce((a, b) => a > b ? a : b) : 10000;

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
            children: [
              Text("All Filters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 18),
              // Price Range Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Price Range (₹${priceRange.start.toInt()} - ₹${priceRange.end.toInt()})",
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
                  "₹${priceRange.start.toInt()}",
                  "₹${priceRange.end.toInt()}",
                ),
                onChanged: (v) {
                  setState(() {
                    priceRange = v;
                  });
                },
              ),
              SizedBox(height: 18),
              // Star Rating Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Star Rating",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (i) {
                  final star = i + 1;
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
                            ? AppColors.primary.withOpacity(0.15)
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
                    final filtered = widget.hotels.where((hotel) {
                      // Price filter
                      double price = (hotel['HotelServices'] != null &&
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
                      bool priceMatch =
                          price >= priceRange.start && price <= priceRange.end;

                      // Star rating filter
                      double star = double.tryParse(
                              hotel['StarRating']?.toString() ?? '0') ??
                          0;
                      bool starMatch =
                          selectedStar == 0 || star.floor() == selectedStar;

                      return priceMatch && starMatch;
                    }).toList();

                    widget.filterCtrl.filteredHotels.assignAll(filtered);
                    widget.filterCtrl.selectedFilter.value = "custom";
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
                    "Apply Filters",
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
                  "Cancel",
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
