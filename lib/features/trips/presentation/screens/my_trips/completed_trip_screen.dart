import 'package:flutter/material.dart';
import 'base_hotel_bookings_screen.dart';

class CompletedTripScreen extends BaseHotelBookingsScreen {
  CompletedTripScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTripScreen> createState() => _CompletedTripScreenState();
}

class _CompletedTripScreenState extends BaseHotelBookingsScreenState<CompletedTripScreen> {
  @override
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings) {
    // Filter for completed bookings (status: completed or check_out_date is in the past)
    final now = DateTime.now();
    return bookings.where((booking) {
      final status = booking['booking_status']?.toString().toLowerCase() ?? '';
      final checkOutDateStr = booking['check_out_date']?.toString() ?? '';
      
      if (status == 'completed') return true;
      
      if (checkOutDateStr.isEmpty) return false;
      
      try {
        final checkOutDate = DateTime.parse(checkOutDateStr.split('T')[0]);
        return checkOutDate.isBefore(now) && (status == 'confirmed' || status == 'completed');
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  String getEmptyStateTitle() => 'No Completed Trips';

  @override
  String getEmptyStateMessage() => 'Your completed trips will appear here';

  @override
  IconData getEmptyStateIcon() => Icons.check_circle_outline;
}

