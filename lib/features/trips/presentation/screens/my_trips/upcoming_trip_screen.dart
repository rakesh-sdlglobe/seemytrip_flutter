import 'package:flutter/material.dart';
import 'base_hotel_bookings_screen.dart';

class UpComingTripScreen extends BaseHotelBookingsScreen {
  UpComingTripScreen({Key? key}) : super(key: key);

  @override
  State<UpComingTripScreen> createState() => _UpComingTripScreenState();
}

class _UpComingTripScreenState extends BaseHotelBookingsScreenState<UpComingTripScreen> {
  @override
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings) {
    // Filter for upcoming bookings (booking_status: pending or confirmed, and check_in_date is in the future)
    final now = DateTime.now();
    return bookings.where((booking) {
      final status = booking['booking_status']?.toString().toLowerCase() ?? '';
      final checkInDateStr = booking['check_in_date']?.toString() ?? '';
      
      if (checkInDateStr.isEmpty) return false;
      
      try {
        final checkInDate = DateTime.parse(checkInDateStr.split('T')[0]);
        final isUpcoming = checkInDate.isAfter(now) || checkInDate.isAtSameMomentAs(now);
        return (status == 'pending' || status == 'confirmed') && isUpcoming;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  String getEmptyStateTitle() => 'No Upcoming Trips';

  @override
  String getEmptyStateMessage() => 'Your upcoming hotel bookings will appear here';

  @override
  IconData getEmptyStateIcon() => Icons.hotel_outlined;
}
