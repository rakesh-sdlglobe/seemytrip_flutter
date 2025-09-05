import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_controller.dart';

class FlightResultsScreen extends StatefulWidget {
  final String tripType; // 'oneway', 'roundtrip', or 'multicity'

  const FlightResultsScreen({
    Key? key,
    required this.tripType,
  }) : super(key: key);

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  final FlightController _flightController = Get.find<FlightController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tripType == 'oneway'
              ? 'One Way Flights'
              : widget.tripType == 'roundtrip'
                  ? 'Round Trip Flights'
                  : 'Multi-City Flights',
        ),
      ),
      body: Obx(() {
        if (_flightController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_flightController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${_flightController.errorMessage.value}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _flightController.retryLastSearch,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final results = _flightController.flightResults;

        if (results.isEmpty) {
          return const Center(child: Text('No flights found'));
        }

        Widget content;
        switch (widget.tripType) {
          case 'oneway':
            content = _buildOneWayView(results);
            break;
          case 'roundtrip':
            content = _buildRoundTripView(results);
            break;
          case 'multicity':
            content = _buildMultiCityView(results);
            break;
          default:
            content = const Center(child: Text('Invalid trip type'));
        }

        return RefreshIndicator(
          onRefresh: _flightController.retryLastSearch,
          child: content,
        );
      }),
    );
  }

  Widget _buildOneWayView(Map<String, dynamic> results) {
    final flights = results['data'] as List<dynamic>? ?? [];

    return ListView.builder(
      controller: _scrollController,
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return _buildFlightCard(flight, isReturn: false);
      },
    );
  }

  Widget _buildRoundTripView(Map<String, dynamic> results) {
    final outboundFlights = results['outbound'] as List<dynamic>? ?? [];
    final returnFlights = results['inbound'] as List<dynamic>? ?? [];

    return ListView.builder(
      controller: _scrollController,
      itemCount: outboundFlights.length,
      itemBuilder: (context, index) {
        final outbound = outboundFlights[index];
        final returnFlight =
            index < returnFlights.length ? returnFlights[index] : null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              _buildFlightCard(outbound, isReturn: false),
              if (returnFlight != null) ...[
                const Divider(),
                _buildFlightCard(returnFlight, isReturn: true),
              ],
              _buildPriceAndBookButton(outbound, returnFlight),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMultiCityView(Map<String, dynamic> results) {
    final segments = _flightController.flightSegments;
    final allFlights = results['segments'] as Map<String, dynamic>? ?? {};

    return ListView.builder(
      controller: _scrollController,
      itemCount: segments.length,
      itemBuilder: (context, index) {
        final segment = segments[index];
        final segmentFlights =
            allFlights['segment_$index'] as List<dynamic>? ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Leg ${index + 1}: ${segment.fromAirport} to ${segment.toAirport}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...segmentFlights
                  .map((flight) => _buildFlightCard(flight))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight,
      {bool isReturn = false}) {
    final departureTime = DateTime.parse(flight['departureTime']);
    final arrivalTime = DateTime.parse(flight['arrivalTime']);
    final duration = arrivalTime.difference(departureTime);

    return ListTile(
      title: Text('${flight['airline']} ${flight['flightNumber']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(flight['origin']),
              const Icon(Icons.flight_takeoff),
              Text(flight['destination']),
            ],
          ),
          const SizedBox(height: 4),
          Text('${_formatTime(departureTime)} - ${_formatTime(arrivalTime)}'),
          Text('${duration.inHours}h ${duration.inMinutes.remainder(60)}m'),
        ],
      ),
      trailing: Text(
        '₹${flight['price']?.toStringAsFixed(2) ?? 'N/A'}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildPriceAndBookButton(
      Map<String, dynamic> outbound, Map<String, dynamic>? returnFlight) {
    final totalPrice = (outbound['price'] as num?)?.toDouble() ?? 0.0;
    final returnPrice = returnFlight != null
        ? (returnFlight['price'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ₹${(totalPrice + returnPrice).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement book now functionality
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
