import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/gallery_view.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_and_homestay.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/hotel_and_home_stay_tab_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Controller/hotel_filter_controller.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'widgets/hotel_list_filter_bar.dart';
import 'widgets/hotel_list_card.dart';
import 'widgets/hotel_filter_bar_full.dart';
import 'widgets/shimmer_hotel_card.dart';

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
    final SearchCityController searchCtrl = Get.find();
    final HotelFilterController filterCtrl = Get.put(HotelFilterController());
    final hotels = List<Map<String, dynamic>>.from(hotelDetails['Hotels'] ?? []);
    final checkInDate = searchCtrl.checkInDate.value;
    final checkOutDate = searchCtrl.checkOutDate.value;
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
      backgroundColor: const Color(
          0xFFE2E2E2), // Light gray background to match card shadows
      body: Stack(
        children: [
          Column(
            children: [
              _HotelScreenHeader(
                cityName: cityName,
                dateRange: dateRange,
                guestInfo: guestInfo,
              ),
              // --- Hotel Filter Section (Ixigo/Train style) ---
              Container(
                color: Colors.white,
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
                        selected: filterCtrl.selectedFilter.value == 'low_price',
                        onTap: () => filterCtrl.applyFilter('low_price', hotels),
                      ),
                      _HotelFilterChip(
                        label: "High Price",
                        icon: Icons.arrow_upward,
                        selected: filterCtrl.selectedFilter.value == 'high_price',
                        onTap: () => filterCtrl.applyFilter('high_price', hotels),
                      ),
                      _HotelFilterChip(
                        label: "Star Rating",
                        icon: Icons.star,
                        selected: filterCtrl.selectedFilter.value == 'star_rating',
                        onTap: () => filterCtrl.applyFilter('star_rating', hotels),
                      ),
                      // Add more filter chips as needed
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                                  color: redCA0.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.filter_alt, color: redCA0, size: 22),
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
                        valueColor: AlwaysStoppedAnimation<Color>(redCA0),
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
                          Icon(Icons.hotel_outlined, size: 48, color: grey717.withOpacity(0.5)),
                          SizedBox(height: 16),
                          Text(
                            filterCtrl.selectedFilter.value != 'all' && hotels.isNotEmpty
                                ? 'No hotels found for selected filters'
                                : 'No hotels found for these dates',
                            style: TextStyle(
                              fontSize: 16,
                              color: grey717,
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// --- Header Widget ---
class _HotelScreenHeader extends StatelessWidget {
  final String cityName;
  final String dateRange;
  final String guestInfo;

  const _HotelScreenHeader({
    Key? key,
    required this.cityName,
    required this.dateRange,
    required this.guestInfo,
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
                  color: white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  horizontalTitleGap: -5,
                  leading: InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: grey888, size: 20),
                  ),
                  title: CommonTextWidget.PoppinsMedium(
                    text: cityName,
                    color: black2E2,
                    fontSize: 15,
                  ),
                  subtitle: CommonTextWidget.PoppinsRegular(
                    text: "$dateRange, $guestInfo",
                    color: grey717,
                    fontSize: 12,
                  ),
                  trailing: InkWell(
                    onTap: () => Get.to(() => HotelAndHomeStayTabScreen()),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(draw),
                        SizedBox(height: 10),
                        CommonTextWidget.PoppinsMedium(
                          text: "Edit",
                          color: redCA0,
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
                onTap: () {},
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: redCA0),
                        CommonTextWidget.PoppinsMedium(
                          text: "Map",
                          color: redCA0,
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
            color: selected ? redCA0.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? redCA0 : greyE2E,
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: redCA0.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? redCA0 : grey717, size: 17),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? redCA0 : grey717,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.check, color: redCA0, size: 15),
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
  State<_HotelFilterBottomSheet> createState() => _HotelFilterBottomSheetState();
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
            ? double.tryParse(h['HotelServices'][0]['ServicePrice'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0
            : double.tryParse(h['MinPrice']?.toString() ?? '0') ?? 0)
        .toList();
    final minPrice = prices.isNotEmpty ? prices.reduce((a, b) => a < b ? a : b) : 0;
    final maxPrice = prices.isNotEmpty ? prices.reduce((a, b) => a > b ? a : b) : 10000;

    // Set initial range only once
    if (priceRange.start == 0 && priceRange.end == 10000 && minPrice != maxPrice) {
      priceRange = RangeValues(minPrice as double, maxPrice as double);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 18),
              // Price Range Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Price Range (₹${priceRange.start.toInt()} - ₹${priceRange.end.toInt()})",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              RangeSlider(
                min: minPrice.toDouble(),
                max: maxPrice == minPrice ? minPrice.toDouble() + 1 : maxPrice.toDouble(),
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
                child: Text("Star Rating", style: TextStyle(fontWeight: FontWeight.w500)),
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
                        color: selectedStar >= star ? redCA0.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedStar >= star ? redCA0 : greyE2E,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.star,
                        color: selectedStar >= star ? Colors.amber : greyE2E,
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
                          ? double.tryParse(hotel['HotelServices'][0]['ServicePrice'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0
                          : double.tryParse(hotel['MinPrice']?.toString() ?? '0') ?? 0;
                      bool priceMatch = price >= priceRange.start && price <= priceRange.end;

                      // Star rating filter
                      double star = double.tryParse(hotel['StarRating']?.toString() ?? '0') ?? 0;
                      bool starMatch = selectedStar == 0 || star.floor() == selectedStar;

                      return priceMatch && starMatch;
                    }).toList();

                    widget.filterCtrl.filteredHotels.assignAll(filtered);
                    widget.filterCtrl.selectedFilter.value = "custom";
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redCA0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Filters",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: TextStyle(color: redCA0, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}