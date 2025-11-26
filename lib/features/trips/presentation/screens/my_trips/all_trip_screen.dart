import 'package:flutter/material.dart';
import 'base_hotel_bookings_screen.dart';

class AllTripScreen extends BaseHotelBookingsScreen {
  AllTripScreen({Key? key}) : super(key: key);

  @override
  State<AllTripScreen> createState() => _AllTripScreenState();
}

class _AllTripScreenState extends BaseHotelBookingsScreenState<AllTripScreen> {
  @override
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings) {
    // Return all bookings without filtering
    return bookings;
  }

  @override
  String getEmptyStateTitle() => 'No Trips';

  @override
  String getEmptyStateMessage() => 'Your hotel bookings will appear here';

  @override
  IconData getEmptyStateIcon() => Icons.hotel_outlined;
}

