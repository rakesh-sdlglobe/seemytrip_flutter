import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seemytrip/shared/models/bus_models.dart';

// Models and other imports

// --- RED THEME COLORS ---
const Color kPrimaryColor = Color(0xFFD32F2F);
const Color kPrimaryDarkColor = Color(0xFFB71C1C);
const Color kPrimaryLightColor = Color(0xFFFFEBEE);
const Color kTextPrimaryColor = Color(0xFF212529);
const Color kTextSecondaryColor = Color(0xFF6C757D);
const Color kCardBackground = Color(0xFFFFFFFF);
const Color kDividerColor = Color(0xFFE9ECEF);

class BusFilterScreen extends StatefulWidget {
  final List<BusSearchResult> results;
  final Function(List<BusSearchResult>) onApplyFilters;
  final ScrollController scrollController; // For DraggableScrollableSheet

  const BusFilterScreen({
    Key? key,
    required this.results,
    required this.onApplyFilters,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<BusFilterScreen> createState() => _BusFilterScreenState();
}

class _BusFilterScreenState extends State<BusFilterScreen> {
  // --- Simplified and Centralized State ---
  late String _currentSort;
  late RangeValues _priceRange;
  late Set<String> _selectedBusTypes;
  late Set<String> _selectedSeatTypes;
  late Set<String> _selectedAmenities;

  // --- Filter Options ---
  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Departure Time',
    'Arrival Time',
    'Duration',
    'Seats Available'
  ];
  final List<String> _busTypeOptions = ['AC', 'Non-AC'];
  final List<String> _seatTypeOptions = ['Seater', 'Sleeper', 'Semi-Sleeper'];
  final List<String> _amenityOptions = [
    'WiFi',
    'Charger',
    'Blanket',
    'Water Bottle'
  ];

  @override
  void initState() {
    super.initState();
    _resetFilters(isInitial: true);
  }
  
  void _resetFilters({bool isInitial = false}) {
    setState(() {
      _currentSort = _sortOptions.first;
      _priceRange = const RangeValues(0, 10000);
      _selectedBusTypes = {};
      _selectedSeatTypes = {};
      _selectedAmenities = {};
    });
    if (!isInitial) {
      widget.onApplyFilters(widget.results);
      Get.back();
    }
  }

  void _applyFilters() {
    List<BusSearchResult> filteredResults = widget.results.where((bus) {
      final price = double.tryParse(bus.fare) ?? 0;
      if (price < _priceRange.start || price > _priceRange.end) return false;

      final busTypeLower = bus.busType.toLowerCase();
      if (_selectedBusTypes.isNotEmpty &&
          !_selectedBusTypes
              .any((type) => busTypeLower.contains(type.toLowerCase())))
        return false;
      if (_selectedSeatTypes.isNotEmpty &&
          !_selectedSeatTypes
              .any((type) => busTypeLower.contains(type.toLowerCase())))
        return false;

      // Assuming 'bus' has amenity booleans like bus.hasWiFi, etc.
      if (_selectedAmenities.contains('WiFi') && !bus.hasWiFi) return false;
      if (_selectedAmenities.contains('Charger') && !bus.hasCharger)
        return false;
      if (_selectedAmenities.contains('Blanket') && !bus.hasBlanket)
        return false;
      if (_selectedAmenities.contains('Water Bottle') && !bus.hasWaterBottle)
        return false;

      return true;
    }).toList();

    // Sorting Logic
    switch (_currentSort) {
      case 'Price: Low to High':
        filteredResults.sort(
            (a, b) => double.parse(a.fare).compareTo(double.parse(b.fare)));
        break;
      case 'Price: High to Low':
        filteredResults.sort(
            (a, b) => double.parse(b.fare).compareTo(double.parse(a.fare)));
        break;
      case 'Departure Time':
        filteredResults
            .sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case 'Arrival Time':
        filteredResults.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        break;
      case 'Duration':
        filteredResults.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case 'Seats Available':
        filteredResults
            .sort((a, b) => b.availableSeats.compareTo(a.availableSeats));
        break;
    }

    widget.onApplyFilters(filteredResults);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildSortView(),
                  _buildFilterSection(
                      title: 'Bus Type',
                      options: _busTypeOptions,
                      selectedSet: _selectedBusTypes),
                  _buildFilterSection(
                      title: 'Seat Type',
                      options: _seatTypeOptions,
                      selectedSet: _selectedSeatTypes),
                  _buildFilterSection(
                      title: 'Amenities',
                      options: _amenityOptions,
                      selectedSet: _selectedAmenities,
                      iconMap: {
                        'WiFi': Icons.wifi,
                        'Charger': Icons.power,
                        'Blanket': Icons.airline_seat_individual_suite_rounded,
                        'Water Bottle': Icons.local_drink
                      }),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: kDividerColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort & Filter',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon:
                    const Icon(Icons.close_rounded, color: kTextSecondaryColor),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelColor: kPrimaryColor,
      unselectedLabelColor: kTextSecondaryColor,
      indicatorColor: kPrimaryColor,
      indicatorWeight: 3.0,
      labelStyle:
          GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      tabs: const [
        Tab(icon: Icon(Icons.sort_rounded), text: 'Sort'),
        Tab(icon: Icon(Icons.directions_bus_filled_rounded), text: 'Bus Type'),
        Tab(icon: Icon(Icons.event_seat_rounded), text: 'Seat Type'),
        Tab(icon: Icon(Icons.widgets_rounded), text: 'Amenities'),
      ],
    );
  }
  
  Widget _buildSortView() {
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(20),
      children: _sortOptions.map((option) {
        return RadioListTile<String>(
          title: Text(option,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          value: option,
          groupValue: _currentSort,
          onChanged: (value) {
            if (value != null) setState(() => _currentSort = value);
          },
          activeColor: kPrimaryColor,
          controlAffinity: ListTileControlAffinity.trailing,
        );
      }).toList(),
    );
  }

  Widget _buildFilterSection(
      {required String title,
      required List<String> options,
      required Set<String> selectedSet,
      Map<String, IconData>? iconMap}) {
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        if (title == "Price Range") ...[
          _buildPriceSlider(),
          const SizedBox(height: 20)
        ],
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            return _buildFilterChip(
              label: option,
              icon: iconMap?[option],
              isSelected: selectedSet.contains(option),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedSet.add(option);
                  } else {
                    selectedSet.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
      {required String label,
      IconData? icon,
      required bool isSelected,
      required ValueChanged<bool> onSelected}) {
    return FilterChip(
      label: Text(label),
      avatar: icon != null
          ? Icon(icon,
              color: isSelected ? Colors.white : kPrimaryColor, size: 18)
          : null,
      selected: isSelected,
      onSelected: onSelected,
      elevation: 0,
      pressElevation: 0,
      backgroundColor: kPrimaryLightColor,
      selectedColor: kPrimaryColor,
      checkmarkColor: Colors.white,
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? Colors.white : kPrimaryDarkColor,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: isSelected ? kPrimaryColor : kDividerColor, width: 1.5),
      ),
    );
  }
  
  Widget _buildPriceSlider() {
    // This can be added to a dedicated "Price" tab if needed
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000,
          divisions: 20,
          activeColor: kPrimaryColor,
          inactiveColor: kPrimaryLightColor,
          labels: RangeLabels(
              '₹${_priceRange.start.round()}', '₹${_priceRange.end.round()}'),
          onChanged: (values) => setState(() => _priceRange = values),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBackground,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
        border: Border(top: BorderSide(color: kDividerColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _resetFilters(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: kPrimaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Reset',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, color: kPrimaryColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Apply',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
