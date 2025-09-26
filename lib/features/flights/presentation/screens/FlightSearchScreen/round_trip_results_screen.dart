import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:seemytrip/core/theme/app_colors.dart';

import '../../controllers/flight_controller.dart';
import '../../widgets/flight_filter_sort_widget.dart';
import 'round_trip_flight_details_screen.dart';

class RoundTripResultsScreen extends StatefulWidget {
  const RoundTripResultsScreen({Key? key}) : super(key: key);

  @override
  State<RoundTripResultsScreen> createState() => _RoundTripResultsScreenState();
}

class _RoundTripResultsScreenState extends State<RoundTripResultsScreen> {
  final FlightController controller = Get.find<FlightController>();

  // Filter and sort state
  final RxMap<String, dynamic> _filters = <String, dynamic>{}.obs;
  final RxString _sortBy = 'price_low_to_high'.obs;

  // Get filtered and sorted flights
  List<dynamic> get _filteredFlights {
    List<dynamic> flights =
        List<dynamic>.from(controller.flightResults['FlightResults'] ?? []);

    // Apply filters
    if (_filters.containsKey('stops')) {
      final int stops = _filters['stops'] as int;
      flights = flights.where((flight) {
        final int stopCount =
            int.tryParse(flight['StopCount']?.toString() ?? '0') ?? 0;
        if (stops == 2) {
          return stopCount >= 2; // 2 or more stops
        }
        return stopCount == stops;
      }).toList();
    }

    if (_filters.containsKey('airline')) {
      final String airline = _filters['airline'] as String;
      flights = flights.where((flight) {
        final String? airlineName =
            flight['AirlineName']?.toString().toLowerCase();
        return airlineName?.contains(airline.toLowerCase()) ?? false;
      }).toList();
    }

    // Apply sorting
    flights.sort((a, b) {
      switch (_sortBy.value) {
        case 'price_low_to_high':
          final double priceA =
              double.tryParse(a['OfferedFare']?.toString() ?? '0') ?? 0;
          final double priceB =
              double.tryParse(b['OfferedFare']?.toString() ?? '0') ?? 0;
          return priceA.compareTo(priceB);

        case 'price_high_to_low':
          final double priceA =
              double.tryParse(a['OfferedFare']?.toString() ?? '0') ?? 0;
          final double priceB =
              double.tryParse(b['OfferedFare']?.toString() ?? '0') ?? 0;
          return priceB.compareTo(priceA);

        case 'duration_short_to_long':
          final int durationA =
              _parseDuration(a['DurationTime']?.toString() ?? '0h 0m');
          final int durationB =
              _parseDuration(b['DurationTime']?.toString() ?? '0h 0m');
          return durationA.compareTo(durationB);

        case 'departure_earliest':
          final String timeA =
              a['DepartureTime']?.toString().split(' ')[1] ?? '23:59';
          final String timeB =
              b['DepartureTime']?.toString().split(' ')[1] ?? '23:59';
          return timeA.compareTo(timeB);

        default:
          return 0;
      }
    });

    return flights;
  }

  // Helper to parse duration string (e.g., "2h 30m") to minutes
  int _parseDuration(String duration) {
    try {
      final List<String> parts = duration.split(' ');
      int hours = 0;
      int minutes = 0;

      for (final String part in parts) {
        if (part.endsWith('h')) {
          hours = int.tryParse(part.replaceAll('h', '')) ?? 0;
        } else if (part.endsWith('m')) {
          minutes = int.tryParse(part.replaceAll('m', '')) ?? 0;
        }
      }

      return hours * 60 + minutes;
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    // Print the flight data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printFlightData();
    });
  }

  void _printFlightData() {
    print('📊 Flight Results Data:');
    print(controller.flightResults);
    print('💰 Total Price: ${controller.totalPrice}');
    print('🎫 Discount: ${controller.discount}');

    // Print last search parameters
    final Map<String, dynamic> params = controller.getLastSearchParams();
    print('🔍 Last Search Parameters:');
    params.forEach((String key, value) {
      print('   - $key: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params = controller.getLastSearchParams();
    final bool hasFilters = _filters.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Available Flights',
          style: GoogleFonts.poppins(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (hasFilters)
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.filter_alt, color: Colors.blue),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                // Clear all filters
                _filters.clear();
                setState(() {});
              },
              tooltip: 'Clear filters',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${params['fromAirport']} → ${params['toAirport']}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatDate(params['departDate'])} • ${params['adults']} Adult${params['adults'] > 1 ? 's' : ''} • ${params['travelClass']} Class',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (params['returnDate'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Round Trip',
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter & Sort Bar
            FlightFilterSortWidget(
              onSortChanged: (value) {
                _sortBy.value = value;
                setState(() {});
              },
              onFilterChanged: (filters) {
                _filters.clear();
                _filters.addAll(filters);
                setState(() {});
              },
            ),
            const SizedBox(height: 8),

            // Active Filters
            if (_filters.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _filters.entries.map((entry) {
                    String filterText = '';
                    if (entry.key == 'stops') {
                      if (entry.value == 0) {
                        filterText = 'Non-stop';
                      } else if (entry.value == 1) {
                        filterText = '1 Stop';
                      } else {
                        filterText = '2+ Stops';
                      }
                    } else if (entry.key == 'airline') {
                      filterText =
                          '${entry.value.toString().split(' ').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ')}';
                    }

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filterText,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              _filters.remove(entry.key);
                              setState(() {});
                            },
                            child: Icon(Icons.close,
                                size: 16, color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Flight Results
            if (_filteredFlights.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredFlights.length,
                itemBuilder: (BuildContext context, int index) {
                  final flight = _filteredFlights[index];
                  return _buildFlightCard(flight);
                },
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.airplanemode_inactive,
                        size: 64,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hasFilters
                            ? 'No flights match your filters.'
                            : 'No flights found for the selected criteria.',
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (hasFilters) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _filters.clear();
                            setState(() {});
                          },
                          child: Text(
                            'Clear all filters',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    // Parse departure and arrival times for outbound flight
    final String departTime =
        flight['DepartureTime']?.toString().split(' ')[1] ?? '--:--';
    final String departDate =
        _formatDate(flight['DepartureTime']?.toString().split(' ')[0]);
    final String arriveTime =
        flight['ArrivalTime']?.toString().split(' ')[1] ?? '--:--';
    final String arriveDate =
        _formatDate(flight['ArrivalTime']?.toString().split(' ')[0]);

    // Parse departure and arrival times for return flight
    final String returnDepartTime =
        flight['ReturnDepartureTime']?.toString().split(' ')[1] ?? '--:--';
    final String returnDepartDate =
        _formatDate(flight['ReturnDepartureTime']?.toString().split(' ')[0]);
    final String returnArriveTime =
        flight['ReturnArrivalTime']?.toString().split(' ')[1] ?? '--:--';
    final String returnArriveDate =
        _formatDate(flight['ReturnArrivalTime']?.toString().split(' ')[0]);

    // Get origin and destination
    final String origin = flight['Origin'] ?? '--';
    final String destination = flight['Destination'] ?? '--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Airline and price
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight['AirlineName']?.toString() ?? 'Flight',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹${flight['OfferedFare']?.toStringAsFixed(0) ?? '0'}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Flight details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: <Widget>[
                // Outbound flight header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flight_takeoff,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Outbound • $departDate',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Outbound flight details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildTimeColumn(
                      time: departTime,
                      location: origin,
                      date: departDate,
                      terminal: flight['Segments']?[0]['Origin']?['Terminal']
                          ?.toString(),
                    ),
                    _buildDurationColumn(
                      duration: flight['DurationTime'] ?? '--',
                      stops: flight['StopCount']?.toString() ?? '0',
                    ),
                    _buildTimeColumn(
                      time: arriveTime,
                      location: destination,
                      date: arriveDate,
                      terminal: flight['Segments']?[0]['Destination']
                              ?['Terminal']
                          ?.toString(),
                      isArrival: true,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Return flight header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.orangeFFB.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flight_land,
                          size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Return • $returnDepartDate',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.orangeEB9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Return flight details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildTimeColumn(
                      time: returnDepartTime,
                      location: destination,
                      date: returnDepartDate,
                      terminal: flight['ReturnSegments']?[0]['Origin']
                              ?['Terminal']
                          ?.toString(),
                    ),
                    _buildDurationColumn(
                      duration: flight['ReturnDuration'] ?? '--',
                      stops: flight['ReturnStopCount']?.toString() ?? '0',
                      isReturn: true,
                    ),
                    _buildTimeColumn(
                      time: returnArriveTime,
                      location: origin,
                      date: returnArriveDate,
                      terminal: flight['ReturnSegments']?[0]['Destination']
                              ?['Terminal']
                          ?.toString(),
                      isArrival: true,
                      isReturn: true,
                    ),
                  ],
                ),

                // Fare details and select button
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Fare details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Fare Details',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Base Fare: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                Text(
                                  '₹${flight['BaseFare']?.toStringAsFixed(0) ?? '0'}, ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                Text(
                                  'Taxes: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                Text(
                                  '₹${flight['Tax']?.toStringAsFixed(0) ?? '0'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                            if (flight['IsRefundable'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  flight['IsRefundable']
                                      ? 'Refundable'
                                      : 'Non-Refundable',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: flight['IsRefundable']
                                        ? AppColors.green00A
                                        : AppColors.orangeEB9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Select button
                      ElevatedButton(
                        onPressed: () async {
                          Get.dialog(
                            Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blue,
                                size: 50,
                              ),
                            ),
                            barrierDismissible: false,
                          );
                          try {
                            // Prepare flight details with all necessary information
                            final Map<String, dynamic> flightDetails = {
                              // Basic flight info
                              'id': flight['id'] ?? '',
                              'airlineName': flight['AirlineName'] ?? '',
                              'flightNumber': flight['FlightNumber'] ?? '',
                              'flightType': 'round_trip',

                              // Outbound flight details
                              'origin': flight['Origin'] ?? '',
                              'destination': flight['Destination'] ?? '',
                              'departureTime': flight['DepartureTime'] ?? '',
                              'arrivalTime': flight['ArrivalTime'] ?? '',
                              'duration': flight['DurationTime'] ?? '',
                              'stopCount': flight['StopCount'] ?? 0,
                              'segments': flight['Segments'] ?? [],

                              // Return flight details
                              'returnDepartureTime':
                                  flight['ReturnDepartureTime'] ?? '',
                              'returnArrivalTime':
                                  flight['ReturnArrivalTime'] ?? '',
                              'returnDuration': flight['ReturnDuration'] ?? '',
                              'returnStopCount': flight['ReturnStopCount'] ?? 0,
                              'returnSegments': flight['ReturnSegments'] ?? [],

                              // Fare details
                              'baseFare': flight['BaseFare'] ?? 0,
                              'tax': flight['Tax'] ?? 0,
                              'totalFare': flight['OfferedFare'] ?? 0,
                              'isRefundable': flight['IsRefundable'] ?? false,
                              'cancellationPolicy':
                                  flight['CancellationPolicy'] ?? '',

                              // Additional info
                              'baggageAllowance':
                                  flight['BaggageAllowance'] ?? '7 kg',
                              'cabinBaggage': flight['CabinBaggage'] ?? '7 kg',
                              'mealIncluded': flight['MealIncluded'] ?? false,
                              'operatedBy': flight['OperatedBy'] ?? '',
                              'aircraftType': flight['AircraftType'] ?? '',
                              'lastBookingTime':
                                  flight['LastBookingTime'] ?? '',
                            };

                            // Navigate to flight details screen
                            await Get.to(() => RoundTripFlightDetailsScreen(
                                  flight: flightDetails,
                                  searchParams:
                                      controller.getLastSearchParams(),
                                ));
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to load flight details',
                              backgroundColor: Colors.red,
                              colorText: AppColors.white,
                            );
                          } finally {
                            // Dismiss the loading dialog
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(
                          'Select',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn({
    required String time,
    required String location,
    String? date,
    String? terminal,
    bool isArrival = false,
    bool isReturn = false,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isArrival
              ? (isReturn ? AppColors.orangeFFB.withOpacity(0.3) : Theme.of(context).primaryColor.withOpacity(0.1))
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isArrival
                    ? (isReturn ? AppColors.orangeEB9 : Theme.of(context).primaryColor)
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              location,
              style: GoogleFonts.poppins(
                color: isArrival
                    ? (isReturn ? AppColors.orangeEB9 : Theme.of(context).primaryColor)
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 13,
                fontWeight: isArrival ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (terminal != null) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                'Terminal $terminal',
                style: GoogleFonts.poppins(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 11,
                ),
              ),
            ],
            if (date != null) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                date,
                style: GoogleFonts.poppins(
                  color: isArrival
                      ? (isReturn ? AppColors.orangeEB9 : Theme.of(context).primaryColor)
                      : Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 11,
                  fontWeight: isArrival ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      );

  Widget _buildDurationColumn({
    required String duration,
    required String stops,
    bool isReturn = false,
  }) =>
      Column(
        children: <Widget>[
          Text(
            duration,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isReturn ? AppColors.orangeEB9 : Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 1,
                width: 80,
                color: Theme.of(context).dividerColor,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isReturn ? AppColors.orangeFFB.withOpacity(0.3) : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stops == '0'
                      ? 'Non-stop'
                      : '$stops ${stops == '1' ? 'stop' : 'stops'}',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isReturn ? AppColors.orangeEB9 : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '--';

    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
