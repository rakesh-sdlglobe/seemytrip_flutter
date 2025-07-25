import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Models/bus_models.dart';

class BusFilterScreen extends StatefulWidget {
  final List<BusSearchResult> results;
  final Function(List<BusSearchResult>) onApplyFilters;

  const BusFilterScreen({
    Key? key,
    required this.results,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<BusFilterScreen> createState() => _BusFilterScreenState();
}

class _BusFilterScreenState extends State<BusFilterScreen> {
  // Filter states
  RangeValues _priceRange = const RangeValues(0, 10000);
  bool _onlyAvailable = false;
  bool _onlyAC = false;
  bool _onlyNonAC = false;
  bool _onlySleeper = false;
  bool _onlySeater = false;
  bool _onlyExpress = false;
  bool _onlySuperLuxury = false;
  bool _onlyVolvo = false;
  bool _onlySemiSleeper = false;
  bool _onlyACSleeper = false;
  bool _onlyACSeater = false;
  bool _onlyNonACSeater = false;
  bool _onlyNonACSleeper = false;
  bool _onlySemiSleeperAC = false;
  bool _onlySemiSleeperNonAC = false;
  bool _onlyVolvoSleeper = false;
  bool _onlyVolvoSeater = false;
  bool _onlyVolvoSemiSleeper = false;
  bool _onlyACExpress = false;
  bool _onlyNonACExpress = false;
  bool _onlySleeperExpress = false;
  bool _onlySeaterExpress = false;

  // Sort states
  String _currentSort = 'Fare (Low to High)';
  final List<String> _sortOptions = [
    'Fare (Low to High)',
    'Fare (High to Low)',
    'Departure Time',
    'Arrival Time',
    'Duration',
    'Seats Available',
  ];

  // Amenities
  bool _wifi = false;
  bool _charger = false;
  bool _blanket = false;
  bool _waterBottle = false;
  bool _snacks = false;
  bool _ac = false;
  bool _sleeper = false;
  bool _seater = false;
  bool _express = false;
  bool _volvo = false;

  // Price options
  List<String> _priceOptions = ['₹0-₹1000', '₹1000-₹2000', '₹2000-₹3000', '₹3000+'];
  String _selectedPriceOption = '₹0-₹1000';

  // Duration options
  List<String> _durationOptions = ['0-4H', '4-8H', '8-12H', '12H+'];
  String _selectedDurationOption = '0-4H';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: redCA0, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Tab Bar
          SizedBox(
            height: 400, // Set a reasonable height for the filter sheet
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: redCA0,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.2,
                        letterSpacing: 0.2,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.2,
                        letterSpacing: 0.2,
                      ),
                      unselectedLabelColor: Colors.black87,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Sort',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.2,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Price',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.2,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Bus Type',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.2,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Amenities',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.2,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Sort Tab
                        _buildSortTab(),
                        
                        // Price Tab
                        _buildPriceTab(),
                        
                        // Bus Type Tab
                        _buildBusTypeTab(),
                        
                        // Amenities Tab
                        _buildAmenitiesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apply Filters Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: redCA0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _sortOptions.map((option) {
          final isSelected = _currentSort == option;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentSort = option;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? redCA0 : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildPriceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Price Range Slider
        Text(
          'Price Range',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000,
          divisions: 20,
          labels: RangeLabels(
            '₹${_priceRange.start.round()}',
            '₹${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        const SizedBox(height: 16),

        // Price Options
        Text(
          'Price Options',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _priceOptions.map((option) {
            return FilterChip(
              label: Text(option),
              selected: _selectedPriceOption == option,
              onSelected: (selected) {
                setState(() {
                  _selectedPriceOption = option;
                  _updatePriceRangeFromOption(option);
                });
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _selectedPriceOption == option ? redCA0 : Colors.black87,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Only Available
        SwitchListTile(
          title: const Text('Only Available Buses'),
          value: _onlyAvailable,
          onChanged: (value) {
            setState(() {
              _onlyAvailable = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBusTypeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AC/Non-AC
        Text(
          'AC Options',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('AC Only'),
              selected: _onlyAC,
              onSelected: (selected) {
                setState(() {
                  _onlyAC = selected;
                  if (selected) {
                    _onlyNonAC = false;
                  }
                });
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlyAC ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Non-AC Only'),
              selected: _onlyNonAC,
              onSelected: (selected) {
                setState(() {
                  _onlyNonAC = selected;
                  if (selected) {
                    _onlyAC = false;
                  }
                });
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlyNonAC ? redCA0 : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Seat Type
        Text(
          'Seat Type',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Sleeper Only'),
              selected: _onlySleeper,
              onSelected: (selected) {
                setState(() {
                  _onlySleeper = selected;
                  if (selected) {
                    _onlySeater = false;
                  }
                });
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlySleeper ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Seater Only'),
              selected: _onlySeater,
              onSelected: (selected) {
                setState(() {
                  _onlySeater = selected;
                  if (selected) {
                    _onlySleeper = false;
                  }
                });
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlySeater ? redCA0 : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Bus Type
        Text(
          'Bus Type',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Express'),
              selected: _onlyExpress,
              onSelected: (selected) {
                setState(() => _onlyExpress = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlyExpress ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Super Luxury'),
              selected: _onlySuperLuxury,
              onSelected: (selected) {
                setState(() => _onlySuperLuxury = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlySuperLuxury ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Volvo'),
              selected: _onlyVolvo,
              onSelected: (selected) {
                setState(() => _onlyVolvo = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _onlyVolvo ? redCA0 : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenitiesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Amenities',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('WiFi'),
              selected: _wifi,
              onSelected: (selected) {
                setState(() => _wifi = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _wifi ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Charger'),
              selected: _charger,
              onSelected: (selected) {
                setState(() => _charger = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _charger ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Blanket'),
              selected: _blanket,
              onSelected: (selected) {
                setState(() => _blanket = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _blanket ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Water Bottle'),
              selected: _waterBottle,
              onSelected: (selected) {
                setState(() => _waterBottle = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _waterBottle ? redCA0 : Colors.black87,
              ),
            ),
            FilterChip(
              label: const Text('Snacks'),
              selected: _snacks,
              onSelected: (selected) {
                setState(() => _snacks = selected);
              },
              selectedColor: redCA0.withOpacity(0.2),
              checkmarkColor: redCA0,
              labelStyle: TextStyle(
                color: _snacks ? redCA0 : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updatePriceRangeFromOption(String option) {
    switch (option) {
      case '₹0-₹1000':
        _priceRange = const RangeValues(0, 1000);
        break;
      case '₹1000-₹2000':
        _priceRange = const RangeValues(1000, 2000);
        break;
      case '₹2000-₹3000':
        _priceRange = const RangeValues(2000, 3000);
        break;
      case '₹3000+':
        _priceRange = const RangeValues(3000, 10000);
        break;
    }
  }

  void _applyFilters() {
    // Filter results based on selected criteria
    List<BusSearchResult> filteredResults = widget.results.where((bus) {
      // Price filter
      final price = double.tryParse(bus.fare) ?? 0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Availability filter
      if (_onlyAvailable && bus.availableSeats <= 0) {
        return false;
      }

      // AC/Non-AC filter
      if (_onlyAC && !bus.busType.toLowerCase().contains('ac')) return false;
      if (_onlyNonAC && bus.busType.toLowerCase().contains('ac')) return false;

      // Seat type filter
      if (_onlySleeper && !bus.busType.toLowerCase().contains('sleeper')) return false;
      if (_onlySeater && bus.busType.toLowerCase().contains('sleeper')) return false;

      // Bus type filter
      if (_onlyExpress && bus.busType != 'Express') return false;
      if (_onlySuperLuxury && bus.busType != 'Super Luxury') return false;
      if (_onlyVolvo && bus.busType != 'Volvo') return false;

      // Amenities filter
      if (_wifi && !bus.hasWiFi) return false;
      if (_charger && !bus.hasCharger) return false;
      if (_blanket && !bus.hasBlanket) return false;
      if (_waterBottle && !bus.hasWaterBottle) return false;
      if (_snacks && !bus.hasSnacks) return false;

      return true;
    }).toList();

    // Sort results
    switch (_currentSort) {
      case 'Fare (Low to High)':
        filteredResults.sort(
            (a, b) => double.parse(a.fare).compareTo(double.parse(b.fare)));
        break;
      case 'Fare (High to Low)':
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

    // Apply filters and close the sheet
    widget.onApplyFilters(filteredResults);
    Navigator.pop(context);
  }
}
