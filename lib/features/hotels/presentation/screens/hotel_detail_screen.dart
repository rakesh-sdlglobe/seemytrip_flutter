import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/common/cards/app_card.dart';
import '../widgets/hotel_detail_amenities.dart';
import '../widgets/hotel_detail_header.dart';
import '../widgets/hotel_detail_overview.dart';
import '../widgets/hotel_images_appbar.dart';
import 'rooms_page.dart';
import 'select_checkin_date_screen.dart';

class HotelDetailScreen extends StatefulWidget {

  const HotelDetailScreen({
    required this.hotelDetails, required this.hotelId, required this.searchParams, Key? key,
  }) : super(key: key);
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  bool _isFavorite = false;

  void _showMapDialog(BuildContext context, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Theme.of(context).cardColor,
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
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const <String>['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.seemytrip',
                ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_pin, 
                        color: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFFFF5722) // Orange-red for dark theme
                          : const Color(0xFFCA0B0B), // Red for light theme
                        size: 30),
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
      final DateTime date = DateTime.parse(dateStr);
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
    final hotelDetail = widget.hotelDetails['HotelDetail'] ?? <dynamic, dynamic>{};
    final String hotelName =
        hotelDetail['HotelName']?.toString() ?? 'No Name Available';
    final String checkIn = widget.searchParams['checkInDate']?.toString() ?? '';
    final String checkOut = widget.searchParams['checkOutDate']?.toString() ?? '';
    final String guests = widget.searchParams['Guests']?.toString() ?? '2 Adults';
    // Get rating with proper type casting
    final double rating = hotelDetail['StarRating'] != null
        ? double.tryParse(hotelDetail['StarRating'].toString()) ?? 0.0
        : 0.0;

    // Format dates
    final String formattedCheckIn = formatDate(checkIn);
    final String formattedCheckOut = formatDate(checkOut);
    final servicePrice =
        widget.hotelDetails['HotelDetail']?['HotelServices']
        ?[0]?['ServicePrice'];

    print("ServicePrice: $servicePrice");

    // Get service price with proper formatting
    final String hotelServicePrice = servicePrice?.toString() ?? '0';

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HotelImagesAppBar(
                    images: hotelDetail['HotelImages'],
                    hotelId: widget.hotelId,
                    isFavorite: _isFavorite,
                    onFavoritePressed: _toggleFavorite,
                  ),
                  // Hotel Header Card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppCard(
                      color: Theme.of(context).cardColor,
                      borderRadius: 12,
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            hotelName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.location_on,
                                    size: 20, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      hotelDetail['HotelAddress']?['City'] ??
                                          'Unknown City',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).textTheme.titleMedium?.color,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      hotelDetail['HotelAddress']?['Address'] ??
                                          'Unknown Address',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.map_outlined,
                                            size: 16, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 6),
                                        Text(
                                          "View on Map",
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
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
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ...List.generate(
                                      rating.floor(),
                                      (int index) => Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                    ),
                                    if (rating - rating.floor() >= 0.5)
                                      Icon(Icons.star_half,
                                          color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.amber[400]
                                          : Colors.amber[800],
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
                                  color: Theme.of(context).textTheme.bodySmall?.color,
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
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
                                children: <Widget>[
                                  Text(
                                    'Travel Dates',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).textTheme.titleMedium?.color,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    checkIn.isNotEmpty && checkOut.isNotEmpty
                                        ? '$formattedCheckIn - $formattedCheckOut'
                                        : 'Select dates',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
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
                                  color: Theme.of(context).primaryColor, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        Divider(
                            height: 24, thickness: 1, color: Theme.of(context).dividerColor),
                        Row(
                          children: <Widget>[
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
                                children: <Widget>[
                                  Text(
                                    'Guests',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).textTheme.titleMedium?.color,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    guests,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
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
                                color: Theme.of(context).textTheme.titleMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ...List.generate(
                                    4,
                                    (int index) => Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                  ),
                                  Icon(Icons.star_half,
                                      color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.5/5',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.amber[400]
                                        : Colors.amber[800],
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
                                color: Theme.of(context).textTheme.bodySmall?.color,
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
                            color: Theme.of(context).textTheme.bodySmall?.color,
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
                                color: Theme.of(context).primaryColor,
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
            color: Theme.of(context).bottomAppBarTheme.color ?? Theme.of(context).cardColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
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
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Starting from',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '₹${hotelServicePrice}',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark 
                                ? const Color(0xFFFF5722) // Orange-red for dark theme
                                : const Color(0xFFCA0B0B), // Red for light theme
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
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Incl. of taxes & fees',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
                        backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFFFF5722) // Orange-red for dark theme
                          : const Color(0xFFCA0B0B), // Red for light theme
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
                          children: <Widget>[
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
