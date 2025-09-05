import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_controller.dart';

class RoundTripResultsScreen extends StatefulWidget {
  const RoundTripResultsScreen({Key? key}) : super(key: key);

  @override
  State<RoundTripResultsScreen> createState() => _RoundTripResultsScreenState();
}

class _RoundTripResultsScreenState extends State<RoundTripResultsScreen> {
  final FlightController _flightController = Get.put(FlightController());
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String _formatTime(String timeString) {
    if (timeString.isEmpty) return '';
    final dt = DateTime.tryParse(timeString);
    return dt != null ? DateFormat.Hm().format(dt) : timeString;
  }

  String _formatDuration(String duration) {
    final mins = int.tryParse(duration) ?? 0;
    final hours = mins ~/ 60;
    final remMins = mins % 60;
    return '${hours}h ${remMins}m';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Round Trip Flights'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 1,
            bottom: TabBar(
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              tabs: [
                Tab(
                  text: 'Outbound',
                  icon: Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                  ),
                ),
                Tab(text: 'Return', icon: Icon(Icons.flight_land, color: Colors.white)),
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 2,
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildResults(isReturn: false),
              _buildResults(isReturn: true),
            ],
          ),
        ),
      );

  Widget _buildResults({required bool isReturn}) => Obx(() {
        if (_flightController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${_flightController.errorMessage.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final results = isReturn
            ? _flightController.returnFlights
            : _flightController.outboundFlights;

        if (_flightController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flight_takeoff, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  isReturn
                      ? 'No return flights found'
                      : 'No outbound flights found',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Price range
        double? minPrice;
        double? maxPrice;
        if (results.isNotEmpty) {
          final prices = results
              .where((f) =>
                  f['Fare'] != null && f['Fare']['PublishedFare'] != null)
              .map((f) => (f['Fare']['PublishedFare'] as num).toDouble())
              .toList()
            ..sort();
          if (prices.isNotEmpty) {
            minPrice = prices.first;
            maxPrice = prices.last;
          }
        }

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${results.length} ${isReturn ? 'Return' : 'Outbound'} Flights',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (minPrice != null && maxPrice != null)
                    Text(
                      '₹${minPrice.toStringAsFixed(0)} - ₹${maxPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final flight = results[index];
                  return _buildFlightCard(flight, isReturn: isReturn);
                },
              ),
            ),
          ],
        );
      });

  Widget _buildFlightCard(Map<String, dynamic> flight,
      {required bool isReturn}) {
    final segments = (flight['Segments'] ?? flight['segments']) is List
        ? (flight['Segments'] ?? flight['segments'])
        : [];

    final firstSegment =
        segments.isNotEmpty && segments[0] is Map ? segments[0] : {};
    final lastSegment =
        segments.isNotEmpty && segments.last is Map ? segments.last : {};

    final departureTime =
        _formatTime(firstSegment['DepartureTime']?.toString() ?? '');
    final arrivalTime =
        _formatTime(lastSegment['ArrivalTime']?.toString() ?? '');
    final duration = _formatDuration(flight['JourneyDuration']?.toString() ?? '');

    dynamic price = 'N/A';
    if (flight['FareDetails'] is Map) {
      price = flight['FareDetails']?['PublishedFare'] ?? 'N/A';
    } else if (flight['fareDetails'] is Map) {
      price = flight['fareDetails']?['publishedFare'] ?? 'N/A';
    }

    final airline = firstSegment['AirlineName']?.toString() ??
        firstSegment['airlineName']?.toString() ??
        firstSegment['Airline']?.toString() ??
        firstSegment['airline']?.toString() ??
        'Unknown Airline';

    final flightNumber = firstSegment['FlightNumber']?.toString() ??
        firstSegment['flightNumber']?.toString() ??
        '';

    final stops = segments is List ? segments.length - 1 : 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline & Price
            Row(
              children: [
                Expanded(
                  child: Text(
                    airline,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Times & Stops
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flight_takeoff,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              departureTime,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        firstSegment['Origin']?.toString() ?? '',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.schedule,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stops == 0
                              ? 'Non-stop'
                              : '$stops ${stops == 1 ? 'stop' : 'stops'}',
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.flight_land,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                arrivalTime,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lastSegment['Destination']?.toString() ?? '',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Flight details
            Text(
              'Flight: $flightNumber • ${flight['CabinClass'] ?? 'Economy'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 6),

            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: navigate to details
                },
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
