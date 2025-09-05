import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_controller.dart';

class MultiCityResultsScreen extends StatefulWidget {
  const MultiCityResultsScreen({Key? key}) : super(key: key);

  @override
  State<MultiCityResultsScreen> createState() => _MultiCityResultsScreenState();
}

class _MultiCityResultsScreenState extends State<MultiCityResultsScreen>
    with SingleTickerProviderStateMixin {
  final FlightController _flightController = Get.find<FlightController>();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _flightController.flightSegments.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Multi-City Flights'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: List.generate(
            _flightController.flightSegments.length,
            (index) => Tab(
              text: '${_flightController.flightSegments[index].fromAirport} → '
                  '${_flightController.flightSegments[index].toAirport}',
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _flightController.flightSegments.length,
          (index) => _buildSegmentResults(index),
        ),
      ),
    );

  Widget _buildSegmentResults(int segmentIndex) => Obx(() {
      if (_flightController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_flightController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text('Error: ${_flightController.errorMessage.value}'),
        );
      }

      final segment = _flightController.flightSegments[segmentIndex];
      final results = _flightController.getSegmentResults(segmentIndex.toString());

      if (results.isEmpty) {
        return Center(child: Text(
            'No flights found for ${segment.fromAirport} to ${segment.toAirport}'));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: results.length,
        itemBuilder: (context, index) {
          final flight = results[index];
          // Build your flight card widget here
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(flight['airline'] ?? 'Unknown Airline'),
              subtitle: Text('${flight['departureTime']} - ${flight['arrivalTime']}'),
              trailing: Text('₹${flight['price'] ?? 'N/A'}'),
            ),
          );
        },
      );
    });
}
