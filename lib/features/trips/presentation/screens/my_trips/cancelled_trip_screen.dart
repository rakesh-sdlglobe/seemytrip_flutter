import 'package:flutter/material.dart';
import 'base_hotel_bookings_screen.dart';

class CancelledTripScreen extends BaseHotelBookingsScreen {
  CancelledTripScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTripScreen> createState() => _CancelledTripScreenState();
}

class _CancelledTripScreenState extends BaseHotelBookingsScreenState<CancelledTripScreen> {
  @override
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings) {
    // Filter for cancelled bookings
    return bookings.where((booking) {
      final status = booking['booking_status']?.toString().toLowerCase() ?? '';
      return status == 'cancelled';
    }).toList();
  }

  @override
  String getEmptyStateTitle() => 'No Cancelled Trips';

  @override
  String getEmptyStateMessage() => 'All updates regarding your cancellation requests are displayed here!';

  @override
  IconData getEmptyStateIcon() => Icons.cancel_outlined;
}
