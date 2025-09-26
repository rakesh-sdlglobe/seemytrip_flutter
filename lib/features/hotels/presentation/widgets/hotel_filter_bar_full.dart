import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/hotel_filter_controller.dart';

class HotelFilterBarFull extends StatelessWidget {

  const HotelFilterBarFull({
    Key? key,
    required this.filterCtrl,
    required this.hotels,
  }) : super(key: key);
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  @override
  Widget build(BuildContext context) {
    // Example filter options, you can fetch from API or pass as param
    final filterOptions = [
      {'label': 'Price', 'icon': Icons.attach_money, 'type': 'price'},
      {'label': 'Star Rating', 'icon': Icons.star, 'type': 'star'},
      {'label': 'Meal Plan', 'icon': Icons.restaurant, 'type': 'meal'},
      {'label': 'Locality', 'icon': Icons.location_city, 'type': 'locality'},
      {'label': 'Amenities', 'icon': Icons.wifi, 'type': 'amenities'},
      {'label': 'Cancellation', 'icon': Icons.cancel, 'type': 'cancellation'},
      // ...add more as per API
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...filterOptions.map((filter) {
              final isSelected = filterCtrl.selectedFilter.value == filter['type'];
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 4),
                child: GestureDetector(
                  onTap: () {
                    // Open bottom sheet for filter type
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      builder: (ctx) => _FilterOptionsSheet(
                        filterCtrl: filterCtrl,
                        hotels: hotels,
                        filterType: filter['type'] as String,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.redCA0.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.redCA0 : AppColors.greyE2E,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.redCA0.withOpacity(0.08),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(filter['icon'] as IconData, color: isSelected ? AppColors.redCA0 : AppColors.grey717, size: 18),
                        SizedBox(width: 6),
                        Text(
                          filter['label'] as String,
                          style: TextStyle(
                            color: isSelected ? AppColors.redCA0 : AppColors.grey717,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(Icons.check, color: AppColors.redCA0, size: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: FilterActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    builder: (ctx) => _FilterAllOptionsSheet(
                      filterCtrl: filterCtrl,
                      hotels: hotels,
                    ),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class FilterActionButton extends StatelessWidget {
  const FilterActionButton({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.redCA0.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.filter_alt, color: AppColors.redCA0, size: 22),
      ),
    );
}

// --- Individual Filter Option Sheet ---
class _FilterOptionsSheet extends StatelessWidget {

  const _FilterOptionsSheet({
    Key? key,
    required this.filterCtrl,
    required this.hotels,
    required this.filterType,
  }) : super(key: key);
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;
  final String filterType;

  @override
  Widget build(BuildContext context) {
    // Example: show different UI per filterType
    Widget content;
    switch (filterType) {
      case 'price':
        content = _PriceSlider(filterCtrl: filterCtrl, hotels: hotels);
        break;
      case 'star':
        content = _StarRatingSelector(filterCtrl: filterCtrl, hotels: hotels);
        break;
      // Add more cases for other filter types
      default:
        content = Center(child: Text('No filter UI implemented for $filterType'));
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter by ${filterType[0].toUpperCase()}${filterType.substring(1)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 18),
            content,
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redCA0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: Text('Close', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- All Filters Sheet ---
class _FilterAllOptionsSheet extends StatefulWidget {

  const _FilterAllOptionsSheet({
    Key? key,
    required this.filterCtrl,
    required this.hotels,
  }) : super(key: key);
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  @override
  State<_FilterAllOptionsSheet> createState() => _FilterAllOptionsSheetState();
}

class _FilterAllOptionsSheetState extends State<_FilterAllOptionsSheet> {
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
      priceRange = RangeValues(minPrice.toDouble(), maxPrice.toDouble());
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Filter Hotels',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.black2E2,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 22),
              // Price Range Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Price Range',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.black2E2),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8E,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('₹${priceRange.start.toInt()}',
                        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black2E2)),
                  ),
                  Expanded(
                    child: RangeSlider(
                      min: minPrice.toDouble(),
                      max: maxPrice == minPrice ? minPrice.toDouble() + 1 : maxPrice.toDouble(),
                      values: priceRange,
                      divisions: maxPrice > minPrice ? 20 : 1,
                      labels: RangeLabels(
                        '₹${priceRange.start.toInt()}',
                        '₹${priceRange.end.toInt()}',
                      ),
                      activeColor: AppColors.redCA0,
                      inactiveColor: AppColors.greyE2E,
                      onChanged: (v) {
                        setState(() {
                          priceRange = v;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8E,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('₹${priceRange.end.toInt()}',
                        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black2E2)),
                  ),
                ],
              ),
              SizedBox(height: 22),
              // Star Rating Filter
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Star Rating',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.black2E2),
                ),
              ),
              SizedBox(height: 8),
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
                        color: selectedStar >= star ? AppColors.redCA0.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedStar >= star ? AppColors.redCA0 : AppColors.greyE2E,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.star,
                        color: selectedStar >= star ? Colors.amber : AppColors.greyE2E,
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
                    widget.filterCtrl.selectedFilter.value = 'custom';
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redCA0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: TextStyle(color: AppColors.redCA0, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Example Filter Widgets ---
class _PriceSlider extends StatefulWidget {
  const _PriceSlider({required this.filterCtrl, required this.hotels});
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  @override
  State<_PriceSlider> createState() => _PriceSliderState();
}

class _PriceSliderState extends State<_PriceSlider> {
  double min = 0;
  double max = 10000;
  RangeValues values = RangeValues(0, 10000);

  @override
  void initState() {
    super.initState();
    // You can set min/max from hotels data if needed
  }

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range (₹${values.start.toInt()} - ₹${values.end.toInt()})'),
        RangeSlider(
          min: min,
          max: max,
          values: values,
          divisions: 20,
          labels: RangeLabels(
            '₹${values.start.toInt()}',
            '₹${values.end.toInt()}',
          ),
          onChanged: (v) {
            setState(() {
              values = v;
            });
            // Optionally: widget.filterCtrl.applyPriceFilter(v.start, v.end, widget.hotels);
          },
        ),
      ],
    );
}

class _StarRatingSelector extends StatefulWidget {
  const _StarRatingSelector({required this.filterCtrl, required this.hotels});
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  @override
  State<_StarRatingSelector> createState() => _StarRatingSelectorState();
}

class _StarRatingSelectorState extends State<_StarRatingSelector> {
  int selectedStar = 0;

  @override
  Widget build(BuildContext context) => Row(
      children: List.generate(5, (i) {
        final star = i + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            color: selectedStar >= star ? Colors.amber : AppColors.greyE2E,
          ),
          onPressed: () {
            setState(() {
              selectedStar = star;
            });
            // Optionally: widget.filterCtrl.applyStarFilter(star, widget.hotels);
          },
        );
      }),
    );
}
