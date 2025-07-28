import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
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

class HotelDetailScreen extends StatefulWidget {
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  const HotelDetailScreen({
    Key? key,
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
  }) : super(key: key);

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  bool _isFavorite = false;

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
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // TODO: Add your favorite toggle logic here (e.g., API call)
  }

  @override
  Widget build(BuildContext context) {
    // Get hotel details with null checks and default values
    final hotelDetail = widget.hotelDetails['HotelDetail'] ?? {};
    final hotelName =
        hotelDetail['HotelName']?.toString() ?? 'No Name Available';
    final checkIn = widget.searchParams['checkInDate']?.toString() ?? '';
    final checkOut = widget.searchParams['checkOutDate']?.toString() ?? '';
    final guests = widget.searchParams['Guests']?.toString() ?? '2 Adults';
    // Get rating with proper type casting
    final rating = hotelDetail['StarRating'] != null
        ? double.tryParse(hotelDetail['StarRating'].toString()) ?? 0.0
        : 0.0;

    // Format dates
    final formattedCheckIn = formatDate(checkIn);
    final formattedCheckOut = formatDate(checkOut);
    final servicePrice =
        widget.hotelDetails['HotelDetail']?['HotelServices']
        ?[0]?['ServicePrice'];

    print("ServicePrice: $servicePrice");

    // Get service price with proper formatting
    final hotelServicePrice = servicePrice?.toString() ?? '0';

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
                    hotelId: widget.hotelId,
                    isFavorite: _isFavorite,
                    onFavoritePressed: _toggleFavorite,
                  ),
                  // Hotel Header Card
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotelName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: redCA0.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.location_on,
                                    size: 20, color: redCA0),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotelDetail['HotelAddress']?['City'] ??
                                          'Unknown City',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      hotelDetail['HotelAddress']?['Address'] ??
                                          'Unknown Address',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (hotelDetail['HotelAddress']?['Latitude'] !=
                                      null &&
                                  hotelDetail['HotelAddress']?['Longitude'] !=
                                      null)
                                InkWell(
                                  onTap: () {
                                    final lat = hotelDetail['HotelAddress']
                                        ?['Latitude'];
                                    final lng = hotelDetail['HotelAddress']
                                        ?['Longitude'];
                                    double? dLat =
                                        double.tryParse(lat.toString());
                                    double? dLng =
                                        double.tryParse(lng.toString());
                                    if (dLat != null && dLng != null) {
                                      _showMapDialog(context, dLat, dLng);
                                    } else {
                                      Get.snackbar(
                                          "Error", "Invalid coordinates.");
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: redCA0.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: redCA0.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.map_outlined,
                                            size: 16, color: redCA0),
                                        SizedBox(width: 6),
                                        Text(
                                          "View on Map",
                                          style: TextStyle(
                                            color: redCA0,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Rating Row
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...List.generate(
                                      rating.floor(),
                                      (index) => Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                    ),
                                    if (rating - rating.floor() >= 0.5)
                                      Icon(Icons.star_half,
                                          color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.amber[800],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "(245 Reviews)",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Travel Dates Card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.calendar_month_outlined,
                                  size: 20, color: Colors.blue),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Travel Dates',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    checkIn.isNotEmpty && checkOut.isNotEmpty
                                        ? '$formattedCheckIn - $formattedCheckOut'
                                        : 'Select dates',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.to(() => SelectCheckInDateScreen());
                              },
                              icon: Icon(Icons.edit_outlined,
                                  color: redCA0, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        Divider(
                            height: 24, thickness: 1, color: Colors.grey[200]),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.people_outline,
                                  size: 20, color: Colors.green),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guests',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    guests,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                  // Overview Card
                  HotelDetailOverview(hotelDetail: hotelDetail),

                  // Amenities Card
                  HotelDetailAmenities(hotelDetail: hotelDetail),

                  // Reviews Card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.star_rate_rounded,
                                  size: 20, color: Colors.amber),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Guest Reviews',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...List.generate(
                                    4,
                                    (index) => Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                  ),
                                  Icon(Icons.star_half,
                                      color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.5/5',
                                    style: TextStyle(
                                      color: Colors.amber[800],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "(245 Reviews)",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "\"Great location, clean rooms, and friendly staff. The service was excellent and the amenities were top-notch. Highly recommended!\"",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to all reviews
                            },
                            child: Text(
                              'View All Reviews',
                              style: TextStyle(
                                color: redCA0,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Starting from',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${hotelServicePrice}',
                            style: TextStyle(
                              color: redCA0,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              'per night',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Incl. of taxes & fees',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => RoomsPage(
                              hotelDetails: widget.hotelDetails,
                              hotelId: widget.hotelId,
                              searchParams: widget.searchParams,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redCA0,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.king_bed_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Select Room',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
