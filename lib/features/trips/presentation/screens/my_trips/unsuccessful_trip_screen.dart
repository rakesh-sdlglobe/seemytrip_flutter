import 'package:flutter/material.dart';
import 'base_hotel_bookings_screen.dart';

class UnsuccessfulTripScreen extends BaseHotelBookingsScreen {
  UnsuccessfulTripScreen({Key? key}) : super(key: key);

  @override
  State<UnsuccessfulTripScreen> createState() => _UnsuccessfulTripScreenState();
}

class _UnsuccessfulTripScreenState extends BaseHotelBookingsScreenState<UnsuccessfulTripScreen> {
  @override
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings) {
    // Filter for unsuccessful bookings (status: failed, rejected, or unsuccessful)
    return bookings.where((booking) {
      final status = booking['booking_status']?.toString().toLowerCase() ?? '';
      return status == 'failed' || 
             status == 'rejected' || 
             status == 'unsuccessful' ||
             (booking['payment_status']?.toString().toLowerCase() == 'failed');
    }).toList();
  }

  @override
  String getEmptyStateTitle() => 'No Unsuccessful Trips';

  @override
  String getEmptyStateMessage() => 'Your unsuccessful trips will appear here';

  @override
  IconData getEmptyStateIcon() => Icons.error_outline;
}

