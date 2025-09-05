import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/common_button_widget.dart';
import '../../../domain/models/flight_segment.dart';
import '../../controllers/flight_controller.dart';

class MultiCityScreen extends StatelessWidget {

  MultiCityScreen({Key? key}) : super(key: key);
  final FlightController _flightController = Get.find<FlightController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Multi-City Flights'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _flightController.flightSegments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _flightController.flightSegments.length) {
                      return _buildAddSegmentButton();
                    }
                    return _buildFlightSegmentCard(index, context);
                  },
                ),
              ),
            ),
            _buildSearchButton(),
          ],
        ),
      ),
    );

  Widget _buildFlightSegmentCard(int index, BuildContext context) {
    final segment = _flightController.flightSegments[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Segment ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_flightController.flightSegments.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _flightController.removeFlightSegment(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLocationField(
              'From',
              segment.fromAirport,
              (value) => _updateSegment(index, fromAirport: value),
            ),
            const SizedBox(height: 8),
            _buildLocationField(
              'To',
              segment.toAirport,
              (value) => _updateSegment(index, toAirport: value),
            ),
            const SizedBox(height: 8),
            _buildDateField(
              'Departure Date',
              segment.departDate,
              (date) => _updateSegment(
                index,
                departDate: DateFormat('yyyy-MM-dd').format(date),
              ),
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField(String label, String value, Function(String) onChanged) => TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Icon(Icons.flight_takeoff),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );

  Widget _buildDateField(String label, String date, Function(DateTime) onDateSelected, BuildContext context) => InkWell(
      onTap: () => _selectDate(context, onDateSelected),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );

  Widget _buildAddSegmentButton() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton.icon(
        onPressed: () {
          if (_flightController.flightSegments.isEmpty) {
            _flightController.addFlightSegment('', '', '');
          } else {
            final lastSegment = _flightController.flightSegments.last;
            _flightController.addFlightSegment(
              lastSegment.toAirport,
              '',
              lastSegment.departDate,
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Another Flight'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

  Widget _buildSearchButton() => Padding(
      padding: const EdgeInsets.all(16.0),
      child: CommonButtonWidget.button(
        buttonColor: Colors.blue,
        onTap: _searchFlights,
        text: "SEARCH FLIGHTS",
      ),
    );

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _updateSegment(
    int index, {
    String? fromAirport,
    String? toAirport,
    String? departDate,
  }) {
    final segment = _flightController.flightSegments[index];
    _flightController.flightSegments[index] = FlightSegment(
      fromAirport: fromAirport ?? segment.fromAirport,
      toAirport: toAirport ?? segment.toAirport,
      departDate: departDate ?? segment.departDate,
      rowNo: index,
    );
  }

  Future<void> _searchFlights() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_flightController.flightSegments.length < 2) {
        Get.snackbar(
          'Error',
          'Please add at least 2 flight segments',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        final results = await _flightController.searchMultiCityFlights(
          segments: _flightController.flightSegments
              .map((segment) => segment.toJson())
              .toList(),
          adults: 1, // You can make this dynamic
        );

        // Navigate to results screen with the search results
        // Get.to(() => FlightResultsScreen(flightData: results));
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to search flights: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}