import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/rooms_page.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/widgets/hotel_images_appbar.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/hotel_detail_header.dart';
import 'widgets/hotel_detail_overview.dart';
import 'widgets/hotel_detail_amenities.dart';

class HotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  HotelDetailScreen({
    Key? key,
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
  }) : super(key: key);

  void _showMapDialog(BuildContext context, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.seemytrip',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: 40,
                      height: 40,
                      child:
                          Icon(Icons.location_pin, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelDetail = hotelDetails['HotelDetail'] ?? {};
    final hotelName = hotelDetail['HotelName'] ?? 'No Name';
    final checkIn = searchParams['checkInDate'] ?? '';
    final checkOut = searchParams['checkOutDate'] ?? '';
    final guests = searchParams['Guests']?.toString() ?? '2 Adults';
    final rating = hotelDetail['StarRating'] != null
        ? double.tryParse(hotelDetail['StarRating'].toString()) ?? 0.0
        : 0.0;

    final formattedCheckIn = formatDate(checkIn);
    final formattedCheckOut = formatDate(checkOut);

    final hotelServicePrice =
        hotelDetails['HotelServices']?[0]?['ServicePrice']?.toString() ?? '0';
    print("hotelServicePrice: $hotelServicePrice");

    return Scaffold(
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HotelImagesAppBar(
                  images: hotelDetail['HotelImages'],
                  hotelId: hotelId,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: hotelName,
                        color: black2E2,
                        fontSize: 20,
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, size: 18, color: redCA0),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: hotelDetail['HotelAddress']?['City'] ??
                                      'Unknown City',
                                  color: black2E2,
                                  fontSize: 15,
                                ),
                                SizedBox(height: 2),
                                CommonTextWidget.PoppinsRegular(
                                  text: hotelDetail['HotelAddress']
                                          ?['Address'] ??
                                      'Unknown Address',
                                  color: grey717,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          if (hotelDetail['HotelAddress']?['Latitude'] !=
                                  null &&
                              hotelDetail['HotelAddress']?['Longitude'] != null)
                            InkWell(
                              onTap: () {
                                final lat =
                                    hotelDetail['HotelAddress']?['Latitude'];
                                final lng =
                                    hotelDetail['HotelAddress']?['Longitude'];
                                double? dLat = double.tryParse(lat.toString());
                                double? dLng = double.tryParse(lng.toString());
                                if (dLat != null && dLng != null) {
                                  _showMapDialog(context, dLat, dLng);
                                } else {
                                  Get.snackbar("Error", "Invalid coordinates.");
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: greyE8E,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.map, size: 15, color: redCA0),
                                    SizedBox(width: 4),
                                    Text(
                                      "View Map",
                                      style: TextStyle(
                                        color: redCA0,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(
                              rating.floor(),
                              (index) => Icon(Icons.star,
                                  color: Colors.amber, size: 18)),
                          if (rating - rating.floor() >= 0.5)
                            Icon(Icons.star_half,
                                color: Colors.amber, size: 18),
                          SizedBox(width: 8),
                          CommonTextWidget.PoppinsMedium(
                            text: "${rating.toStringAsFixed(1)}/5",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: " (245 Reviews)",
                            color: grey717,
                            fontSize: 14,
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: redCA0),
                            SizedBox(width: 8),
                            CommonTextWidget.PoppinsMedium(
                              text: "Travel Dates: ",
                              color: black2E2,
                              fontSize: 12,
                            ),
                            Text(
                              checkIn.isNotEmpty && checkOut.isNotEmpty
                                  ? "$formattedCheckIn - $formattedCheckOut"
                                  : "N/A",
                              style: TextStyle(
                                color: black2E2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.person, size: 16, color: redCA0),
                            SizedBox(width: 4),
                            CommonTextWidget.PoppinsMedium(
                              text: "Guests: ",
                              color: black2E2,
                              fontSize: 13,
                            ),
                            Text(
                              guests,
                              style: TextStyle(
                                color: black2E2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Get.to(() => SelectCheckInDateScreen());
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: greyE8E,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 16, color: redCA0),
                                    SizedBox(width: 4),
                                    Text(
                                      "Modify",
                                      style: TextStyle(
                                        color: redCA0,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                HotelDetailHeader(
                  hotelDetail: hotelDetail,
                  hotelName: hotelName,
                  rating: rating,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  guests: guests,
                  formattedCheckIn: formattedCheckIn,
                  formattedCheckOut: formattedCheckOut,
                ),
                SizedBox(height: 7),
                Divider(color: greyE8E, thickness: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HotelDetailOverview(hotelDetail: hotelDetail),
                      SizedBox(height: 22),
                      HotelDetailAmenities(hotelDetail: hotelDetail),
                      SizedBox(height: 22),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 6),
                          Text("4.5/5",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text("(245 Reviews)",
                              style: TextStyle(color: grey717)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "\"Great location, clean rooms, friendly staff.\"",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: grey717),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyle(
                      color: grey717,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₹${hotelServicePrice}',
                    style: TextStyle(
                      color: redCA0,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(() => RoomsPage(
                      hotelDetails: hotelDetails,
                      hotelId: hotelId,
                      searchParams: searchParams,
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: redCA0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Select Room',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
