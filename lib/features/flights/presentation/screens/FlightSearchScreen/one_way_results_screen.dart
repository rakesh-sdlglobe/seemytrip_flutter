import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_controller.dart';
import 'package:shimmer/shimmer.dart';

class OneWayResultsScreen extends StatefulWidget {
  const OneWayResultsScreen({Key? key}) : super(key: key);

  @override
  State<OneWayResultsScreen> createState() => _OneWayResultsScreenState();
}

class _OneWayResultsScreenState extends State<OneWayResultsScreen> {
  final FlightController _flightController = Get.find<FlightController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(String timeString) {
    if (timeString.isEmpty) return '';
    final DateTime? dt = DateTime.tryParse(timeString);
    return dt != null ? DateFormat('hh:mm a').format(dt) : timeString;
  }

  String _formatDuration(String duration) {
    final int mins = int.tryParse(duration) ?? 0;
    final int hours = mins ~/ 60;
    final int remMins = mins % 60;
    return '${hours}h ${remMins}m';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Available Flights',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        body: _buildResults(),
      );

  Widget _buildResults() => Obx(() {
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

        final RxMap<String, dynamic> response = _flightController.flightResults;
        if (response == null) {
          return _buildShimmerLoading(); // shimmer while waiting
        }

        if (response['FlightResults'] == null) {
          return const Center(child: Text('No flight data available'));
        }

        final List<dynamic> flights =
            response['FlightResults'] is List ? response['FlightResults'] : <dynamic>[];
        if (flights.isEmpty) {
          return const Center(
              child: Text('No flights found for your search criteria'));
        }

        return Column(
          children: <Widget>[
            _buildFilterSection(response['Filter'] ?? <String, dynamic>{}),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${flights.length} flights found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${response['Filter']?['MinPrice'] != null ? '₹${response['Filter']?['MinPrice']}' : ''} - ${response['Filter']?['MaxPrice'] != null ? '₹${response['Filter']?['MaxPrice']}' : ''}',
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: flights.length,
                itemBuilder: (BuildContext context, int index) {
                  final flight = flights[index];
                  return _buildFlightCard(flight);
                },
              ),
            ),
          ],
        );
      });

  Widget _buildFilterSection(Map<String, dynamic> filters) => Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: <Widget>[
                _buildFilterChip('Stops',
                    filters['Stop']?.toString().split('|').first ?? 'Any'),
                _buildFilterChip(
                    'Airlines',
                    (filters['Airline']?.toString().split('|').length ?? 0)
                            .toString() +
                        ' Airlines'),
                _buildFilterChip('Price',
                    '₹${filters['MinPrice'] ?? ''} - ₹${filters['MaxPrice'] ?? ''}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.indigo),
            onPressed: () {},
          )
        ],
      ),
    );

  Widget _buildFilterChip(String label, String value) => Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    final segments = (flight['Segments'] ?? flight['segments']) is List
        ? (flight['Segments'] ?? flight['segments'])
        : <dynamic>[];

    final firstSegment =
        segments.isNotEmpty && segments[0] is Map ? segments[0] : <dynamic, dynamic>{};
    final lastSegment =
        segments.isNotEmpty && segments.last is Map ? segments.last : <dynamic, dynamic>{};

    final String departureTime =
        _formatTime(firstSegment['DepartureTime']?.toString() ?? '');
    final String arrivalTime =
        _formatTime(lastSegment['ArrivalTime']?.toString() ?? '');
    final String duration =
        _formatDuration(flight['JourneyDuration']?.toString() ?? '');

    dynamic price = 'N/A';
    if (flight['FareDetails'] is Map) {
      price = flight['FareDetails']?['PublishedFare'] ?? 'N/A';
    } else if (flight['fareDetails'] is Map) {
      price = flight['fareDetails']?['publishedFare'] ?? 'N/A';
    }

    final String airline = firstSegment['AirlineName']?.toString() ??
        firstSegment['airlineName']?.toString() ??
        firstSegment['Airline']?.toString() ??
        firstSegment['airline']?.toString() ??
        'Unknown Airline';

    final String flightNumber = firstSegment['FlightNumber']?.toString() ??
        firstSegment['flightNumber']?.toString() ??
        '';

    final int stops = segments is List ? segments.length - 1 : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Airline & Price
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    airline,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Colors.red, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹$price',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Flight details row
            // Flight details row
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: _buildTimeColumn(
                    Icons.flight_takeoff,
                    departureTime,
                    firstSegment['Origin']?.toString() ?? '',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        duration,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stops == 0
                            ? 'Non-stop'
                            : '$stops ${stops == 1 ? 'stop' : 'stops'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.indigo,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildTimeColumn(
                    Icons.flight_land,
                    arrivalTime,
                    lastSegment['Destination']?.toString() ?? '',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Flight number + cabin class
            Text(
              'Flight: $flightNumber • ${flight['CabinClass'] ?? 'Economy'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(IconData icon, String time, String place) => Column(
      children: <Widget>[
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          place,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );

  Widget _buildShimmerLoading() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
    );
}
