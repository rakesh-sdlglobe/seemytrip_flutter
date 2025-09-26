import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../train/presentation/screens/train_modify_search_screen.dart';
import '../../controllers/flight_controller.dart';
import '../../widgets/flight_filter_sort_widget.dart';
import 'one_way_flight_details_screen.dart';

class OneWayResultsScreen extends StatefulWidget {
  const OneWayResultsScreen({Key? key}) : super(key: key);

  @override
  State<OneWayResultsScreen> createState() => _OneWayResultsScreenState();
}

class _OneWayResultsScreenState extends State<OneWayResultsScreen> {
  final FlightController controller = Get.find<FlightController>();
  late Map<String, dynamic> flightData;
  late Map<String, dynamic> searchParams;
  late List<dynamic> flights;
  
  // Filter and sort state
  final RxMap<String, dynamic> _filters = <String, dynamic>{}.obs;
  final RxString _sortBy = 'price_low_to_high'.obs;
  
  // Get filtered and sorted flights
  List<dynamic> get _filteredFlights {
    List<dynamic> filteredFlights = List<dynamic>.from(flights);
    
    // Apply filters
    if (_filters.containsKey('stops')) {
      final int stops = _filters['stops'] as int;
      filteredFlights = filteredFlights.where((flight) {
        final int stopCount = int.tryParse(flight['StopCount']?.toString() ?? '0') ?? 0;
        if (stops == 2) {
          return stopCount >= 2; // 2 or more stops
        }
        return stopCount == stops;
      }).toList();
    }
    
    if (_filters.containsKey('airline')) {
      final String airline = _filters['airline'] as String;
      filteredFlights = filteredFlights.where((flight) {
        final String? airlineName = flight['AirlineName']?.toString().toLowerCase();
        return airlineName?.contains(airline.toLowerCase()) ?? false;
      }).toList();
    }
    
    // Apply sorting
    filteredFlights.sort((a, b) {
      switch (_sortBy.value) {
        case 'price_low_to_high':
          final double priceA = double.tryParse(a['OfferedFare']?.toString() ?? '0') ?? 0;
          final double priceB = double.tryParse(b['OfferedFare']?.toString() ?? '0') ?? 0;
          return priceA.compareTo(priceB);
          
        case 'price_high_to_low':
          final double priceA = double.tryParse(a['OfferedFare']?.toString() ?? '0') ?? 0;
          final double priceB = double.tryParse(b['OfferedFare']?.toString() ?? '0') ?? 0;
          return priceB.compareTo(priceA);
          
        case 'duration_short_to_long':
          final int durationA = _parseDuration(a['DurationTime']?.toString() ?? '0h 0m');
          final int durationB = _parseDuration(b['DurationTime']?.toString() ?? '0h 0m');
          return durationA.compareTo(durationB);
          
        case 'departure_earliest':
          final String timeA = a['DepartureTime']?.toString().split(' ')[1] ?? '23:59';
          final String timeB = b['DepartureTime']?.toString().split(' ')[1] ?? '23:59';
          return timeA.compareTo(timeB);
          
        default:
          return 0;
      }
    });
    
    return filteredFlights;
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
    final args = Get.arguments ?? {};
    flightData = args['flightData'] ?? {};
    searchParams = args['searchParams'] ?? controller.getLastSearchParams();
    flights = (flightData['FlightResults'] as List<dynamic>?) ?? [];
    
    // Print flight data for debugging
    _printFlightData();
  }

  void _printFlightData() {
    print('📊 One Way Flight Results Data:');
    print(flightData);
    print('🔍 Search Parameters:');
    searchParams.forEach((key, value) {
      print('   - $key: $value');
    });
  }

  @override
  Widget build(BuildContext context) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.redCA0,
              secondary: AppColors.redCA0,
              onPrimary: AppColors.white,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redCA0,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Theme.of(context).textTheme.bodyLarge?.color,
              displayColor: Theme.of(context).textTheme.displayLarge?.color,
            ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Select Flight',
            style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Get.back(),
          ),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: Theme.of(context).brightness == Brightness.dark ? 8 : 4,
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
                                '${searchParams['fromAirport']} → ${searchParams['toAirport']}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatDate(searchParams['departDate'])} • ${searchParams['adults']} Adult${searchParams['adults'] > 1 ? 's' : ''} • ${searchParams['travelClass']} Class',
                                style: GoogleFonts.poppins(
                                  color: AppColors.grey717,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.redCA0.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'One Way',
                            style: GoogleFonts.poppins(
                              color: AppColors.redCA0,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        filterText = '${entry.value.toString().split(' ').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ')}';
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
color: AppColors.redCA0.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.redCA0.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filterText,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.redCA0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                _filters.remove(entry.key);
                                setState(() {});
                              },
                              child: Icon(Icons.close, size: 16, color: AppColors.blueCA0),
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
                    final Map<String, dynamic> flight = _filteredFlights[index];
                    return GestureDetector(
                      onTap: () {
                        // Debug print the original flight data
                        print('🔄 Original Flight Data:');
                        flight.forEach((key, value) {
                          print('   - $key: $value');
                        });

                        // Create a properly structured flight object with all necessary fields
                        final Map<String, dynamic> flightDetails = {
                          'segments': [{
                            // Airline info
                            'Airline': flight['Airline'],
                            'AirlineName': flight['AirlineName'] ?? flight['Airline']?['Name'],
                            'AirlineCode': flight['AirlineCode'] ?? flight['Airline']?['Code'],
                            'FlightNumber': flight['FlightNumber'] ?? flight['FlightNo'],
                            'Carrier': flight['Carrier'] ?? flight['AirlineCode'],
                            
                            // Flight times
                            'DepartureTime': flight['DepartureTime'] ?? flight['Departure'],
                            'ArrivalTime': flight['ArrivalTime'] ?? flight['Arrival'],
                            'Departure': flight['DepartureTime'] ?? flight['Departure'],
                            'Arrival': flight['ArrivalTime'] ?? flight['Arrival'],
                            'departure': flight['DepartureTime'] ?? flight['Departure'],
                            'arrival': flight['ArrivalTime'] ?? flight['Arrival'],
                            'Duration': flight['DurationTime'] ?? flight['Duration'],
                            'DurationTime': flight['DurationTime'] ?? flight['Duration'],
                            'TravelTime': flight['TravelTime'] ?? flight['DurationTime'],
                            
                            // Route info
                            'Origin': flight['Origin'] ?? flight['From'] ?? searchParams['fromAirport'],
                            'Destination': flight['Destination'] ?? flight['To'] ?? searchParams['toAirport'],
                            'From': flight['From'] ?? flight['Origin'] ?? searchParams['fromAirport'],
                            'To': flight['To'] ?? flight['Destination'] ?? searchParams['toAirport'],
                            'origin': flight['origin'] ?? flight['Origin'] ?? flight['From'] ?? searchParams['fromAirport'],
                            'destination': flight['destination'] ?? flight['Destination'] ?? flight['To'] ?? searchParams['toAirport'],
                            
                            // Flight details
                            'AircraftType': flight['AircraftType'] ?? flight['Aircraft'] ?? 'N/A',
                            'Baggage': flight['Baggage'] ?? flight['BaggageAllowance'] ?? 'Check with airline',
                            'CabinBaggage': flight['CabinBaggage'] ?? flight['HandBaggage'] ?? '7 kg',
                            'StopCount': flight['StopCount'] ?? flight['Stops'] ?? 0,
                            'Stops': flight['Stops'] ?? flight['StopCount'] ?? 0,
                            'FlightId': flight['FlightId'] ?? flight['Id'],
                            'AvailableSeats': flight['AvailableSeats'],
                            'BookingClass': flight['BookingClass'],
                            'CabinClass': flight['CabinClass'],
                            'FareBasis': flight['FareBasis'],
                            'FareType': flight['FareType'],
                            'FareRule': flight['FareRule'],
                            'Meal': flight['Meal'],
                            'Refundable': flight['Refundable'],
                            'TicketType': flight['TicketType'],
                          }],
                          
                          // Pricing
                          'totalFare': flight['OfferedFare'] ?? flight['Fare'] ?? flight['Price'],
                          'baseFare': flight['BaseFare'] ?? (flight['OfferedFare'] != null ? flight['OfferedFare'] * 0.7 : null),
                          'taxesAndFees': (flight['Tax'] ?? 0) + (flight['OtherCharges'] ?? 0) + (flight['AdditionalTxnFeeOfrd'] ?? 0) + (flight['AdditionalTxnFeePub'] ?? 0),
                          'OfferedFare': flight['OfferedFare'],
                          'PublishedFare': flight['PublishedFare'],
                          'Tax': flight['Tax'],
                          'OtherCharges': flight['OtherCharges'],
                          'AdditionalTxnFeeOfrd': flight['AdditionalTxnFeeOfrd'],
                          'AdditionalTxnFeePub': flight['AdditionalTxnFeePub'],
                          'Currency': flight['Currency'] ?? 'INR',
                          
                          // Flight summary
                          'airlineCode': flight['AirlineCode'] ?? flight['Airline']?['Code'],
                          'airlineName': flight['AirlineName'] ?? flight['Airline']?['Name'],
                          'flightNumber': flight['FlightNumber'] ?? flight['FlightNo'],
                          'departureTime': flight['DepartureTime'] ?? flight['Departure'],
                          'arrivalTime': flight['ArrivalTime'] ?? flight['Arrival'],
                          'duration': flight['DurationTime'] ?? flight['Duration'],
                          'stopCount': flight['StopCount'] ?? flight['Stops'] ?? 0,
                          'origin': flight['Origin'] ?? flight['From'] ?? searchParams['fromAirport'],
                          'destination': flight['Destination'] ?? flight['To'] ?? searchParams['toAirport'],
                          'departureDate': flight['DepartureDate'] ?? searchParams['departDate'],
                          'returnDate': flight['ReturnDate'] ?? searchParams['returnDate'],
                        };

                        print('🚀 Passing flight details to FlightDetailsScreen:');
                        print(flightDetails);

                        Get.to(
                          () => OneWayFlightDetailsScreen(
                            flight: flightDetails,
                            searchParams: searchParams,
                          ),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: _buildFlightCard(flight),
                    );
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
                          color: AppColors.redCA0.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filters.isNotEmpty
                              ? 'No flights match your filters.'
                              : 'No flights found for the selected criteria.',
                          style: GoogleFonts.poppins(
                            color: AppColors.grey717,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_filters.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _filters.clear();
                              setState(() {});
                            },
                            child: Text(
                              'Clear all filters',
                              style: GoogleFonts.poppins(
                                color: AppColors.redCA0,
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
      ),
    );

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    // Parse departure and arrival times
    final String departTime = flight['DepartureTime']?.toString().split(' ')[1] ?? '--:--';
    final String departDate = _formatDate(flight['DepartureTime']?.toString().split(' ')[0]);
    final String arriveTime = flight['ArrivalTime']?.toString().split(' ')[1] ?? '--:--';
    final String arriveDate = _formatDate(flight['ArrivalTime']?.toString().split(' ')[0]);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.grey717.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Flight details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: <Widget>[
                // Airline and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      flight['AirlineName']?.toString() ?? 'Flight',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '₹${(flight['OfferedFare'] ?? flight['Price']).toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.redCA0,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Flight times
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildTimeColumn(
                      time: departTime,
                      location: flight['Origin'] ?? '--',
                      date: departDate,
                      terminal: flight['Segments']?[0]['Origin']?['Terminal']?.toString(),
                    ),
                    _buildDurationColumn(
                      duration: flight['DurationTime'] ?? '--',
                      stops: flight['StopCount']?.toString() ?? '0',
                    ),
                    _buildTimeColumn(
                      time: arriveTime,
                      location: flight['Destination'] ?? '--',
                      date: arriveDate,
                      terminal: flight['Segments']?[0]['Destination']?['Terminal']?.toString(),
                      isArrival: true,
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
                                color: AppColors.grey717,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Base Fare: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.grey717,
                                  ),
                                ),
                                Text(
                                  '₹${flight['BaseFare']?.toStringAsFixed(0) ?? '0'}, ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey717,
                                  ),
                                ),
                                Text(
                                  'Taxes: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.grey717,
                                  ),
                                ),
                                Text(
                                  '₹${flight['Tax']?.toStringAsFixed(0) ?? '0'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey717,
                                  ),
                                ),
                              ],
                            ),
                            if (flight['IsRefundable'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  flight['IsRefundable'] ? 'Refundable' : 'Non-Refundable',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: flight['IsRefundable'] ? AppColors.green00A : AppColors.orangeEB9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Select button
                      ElevatedButton(
                        onPressed: () {
                          // Handle flight selection
                          // You can add navigation to booking screen here
                          Get.to(() => OneWayFlightDetailsScreen(flight: flight, searchParams: searchParams));  
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redCA0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
  }) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(
      color: isArrival ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
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
            color: isArrival ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          location,
          style: GoogleFonts.poppins(
            color: isArrival ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
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
            _formatDate(date),
            style: GoogleFonts.poppins(
              color: isArrival ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodySmall?.color,
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
  }) => Column(
    children: <Widget>[
      Text(
        duration,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyMedium?.color,
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
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              stops == '0' ? 'Non-stop' : '$stops ${stops == '1' ? 'stop' : 'stops'}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodyLarge?.color,
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

  Widget _buildHeader(BuildContext context, Map<String, dynamic> searchParams) => Container(
        height: 145,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              horizontalTitleGap: -5,
              title: CommonTextWidget.PoppinsRegular(
                text: '${searchParams['fromAirport']} - ${searchParams['toAirport']}',
                color: AppColors.black2E2,
                fontSize: 15,
              ),
              subtitle: CommonTextWidget.PoppinsRegular(
                text: DateFormat('dd MMM, EEEE').format(DateTime.now()),
                color: AppColors.grey717,
                fontSize: 12,
              ),
              trailing: InkWell(
                onTap: () {
                  Get.to(() => TrainModifySearchScreen(
                        startStation: searchParams['fromAirport'],
                        endStation: searchParams['toAirport'],
                        selectedDate: DateTime.now(),
                      ));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(draw),
                    const SizedBox(height: 10),
                    CommonTextWidget.PoppinsMedium(
                      text: 'Edit',
                      color: AppColors.redCA0,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildDateAndPassengerInfo(Map<String, dynamic> params) {
    final dateFormat = DateFormat('E, dd MMM yyyy');
    DateTime date = DateTime.tryParse(params['departDate'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.grey2E2),
              const SizedBox(width: 4),
              Text(dateFormat.format(date),
                  style: TextStyle(fontSize: 12, color: AppColors.grey2E2, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: AppColors.grey2E2),
              const SizedBox(width: 4),
              Text(
                '${params['adults'] ?? 1} Adult${params['adults'] != null && params['adults'] > 1 ? 's' : ''}'
                '${params['children'] != null && params['children'] > 0 ? ', ${params['children']} Child${params['children'] > 1 ? 'ren' : ''}' : ''}',
                style: TextStyle(fontSize: 12, color: AppColors.grey2E2, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() => Container(
        height: 60,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          scrollDirection: Axis.horizontal,
          children: [
            _buildFilterChip('Non-stop', Icons.flight_takeoff),
            const SizedBox(width: 8),
            _buildFilterChip('Morning', Icons.wb_sunny_outlined),
            const SizedBox(width: 8),
            _buildFilterChip('Afternoon', Icons.wb_sunny),
            const SizedBox(width: 8),
            _buildFilterChip('Evening', Icons.nights_stay_outlined),
            const SizedBox(width: 8),
            _buildFilterChip('Airlines', Icons.airplanemode_active),
          ],
        ),
      );

  Widget _buildFilterChip(String label, IconData icon) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.grey2E2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: AppColors.grey2E2),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyLarge?.color)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildSortOptions() => Container(
        height: 60,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          scrollDirection: Axis.horizontal,
          children: [
            _buildSortOption('Price', Icons.attach_money_rounded),
            const SizedBox(width: 12),
            _buildSortOption('Duration', Icons.access_time_rounded),
            const SizedBox(width: 12),
            _buildSortOption('Departure', Icons.flight_takeoff_rounded),
            const SizedBox(width: 12),
            _buildSortOption('Arrival', Icons.flight_land_rounded),
          ],
        ),
      );

  Widget _buildSortOption(String label, IconData icon) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey2E2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: AppColors.grey2E2),
                  const SizedBox(width: 6),
                  Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.grey2E2)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 18, color: AppColors.grey2E2),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildDetailItem(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 16, color: AppColors.grey2E2),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      );
}
