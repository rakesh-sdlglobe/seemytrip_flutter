import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_search_screen.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelDetailHeader extends StatelessWidget {
  final Map<String, dynamic> hotelDetail;
  final String hotelName;
  final double rating;
  final String checkIn;
  final String checkOut;
  final String guests;
  final String formattedCheckIn;
  final String formattedCheckOut;

  const HotelDetailHeader({
    Key? key,
    required this.hotelDetail,
    required this.hotelName,
    required this.rating,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.formattedCheckIn,
    required this.formattedCheckOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ...existing code for image carousel, header, address, rating, dates, guests, etc...
    // Move the header UI code from HotelDetailScreen here.
    // Keep this widget focused on the top section only.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ...existing code for images, back/search/fav, etc...
        // ...existing code for hotel name, address, rating, dates, guests, etc...
      ],
    );
  }
}
