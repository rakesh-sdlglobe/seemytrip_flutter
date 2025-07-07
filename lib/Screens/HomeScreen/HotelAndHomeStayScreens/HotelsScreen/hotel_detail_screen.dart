import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_search_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_image_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/rate_plan_detail_screen.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/main.dart';
import 'package:intl/intl.dart';

class HotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  HotelDetailScreen(
      {Key? key,
      required this.hotelDetails,
      required this.hotelId,
      required this.searchParams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelDetail = hotelDetails['HotelDetail'] ?? {};
    final hotelName = hotelDetail['HotelName'] ?? 'Hotel';
    final hotelRooms =
        List<Map<String, dynamic>>.from(hotelDetail['HotelRooms'] ?? []);
    final hotelId = hotelDetail['HotelProviderSearchId']?.toString() ?? '';
    final starRating = hotelDetail['StarRating'] ?? '0';
    final double rating = starRating is String
        ? double.tryParse(starRating) ?? 0.0
        : (starRating as num).toDouble();

    // Use searchParams for check-in, check-out, and guests
    final checkIn = searchParams['checkInDate'] ?? '';
    final checkOut = searchParams['checkOutDate'] ?? '';
    final guests = searchParams['Guests']?.toString() ?? '2 Adults';
    String formatDate(String dateStr) {
      if (dateStr.isEmpty) return '';
      final date = DateTime.tryParse(dateStr);
      return date != null ? DateFormat('MMM dd').format(date) : '';
    }

    final formattedCheckIn = formatDate(checkIn);
    final formattedCheckOut = formatDate(checkOut);

    // Print for debug
    print('CheckIn: $checkIn');
    print('CheckOut: $checkOut');
    print('Guests: $guests');

    // Get hotel-level price from HotelServices[0]['ServicePrice']
    final hotelServices = hotelDetail['HotelServices'] as List<dynamic>?;
    final hotelServicePrice = hotelServices != null &&
            hotelServices.isNotEmpty &&
            hotelServices[0]['ServicePrice'] != null
        ? hotelServices[0]['ServicePrice'].toString()
        : hotelDetail['Price']?.toString() ?? 'N/A';

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Images Carousel with overlayed controls
                  Container(
                    height: 250,
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: hotelDetail['HotelImages'] != null &&
                              hotelDetail['HotelImages'] is List &&
                              hotelDetail['HotelImages'].isNotEmpty
                          ? null
                          : DecorationImage(
                              image: AssetImage(hotelDetailTopImage),
                              fit: BoxFit.fill,
                            ),
                    ),
                    child: hotelDetail['HotelImages'] != null &&
                            hotelDetail['HotelImages'] is List &&
                            hotelDetail['HotelImages'].isNotEmpty
                        ? Stack(
                            children: [
                              PageView.builder(
                                itemCount: hotelDetail['HotelImages'].length,
                                itemBuilder: (context, index) {
                                  final images = hotelDetail['HotelImages'];
                                  return Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                              // Dots indicator
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      hotelDetail['HotelImages'].length,
                                      (dotIndex) => Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Back, search, heart, and View All
                              Positioned(
                                top: 30,
                                left: 24,
                                right: 24,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: SvgPicture.asset(
                                          internationalDetailBackImage),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() =>
                                                HotelDetailSearchScreen());
                                          },
                                          child: SvgPicture.asset(
                                              internationalDetailSearchImage),
                                        ),
                                        SizedBox(width: 20),
                                        SvgPicture.asset(hotelDetailHeartIcon),
                                        SizedBox(width: 20),
                                        MaterialButton(
                                          onPressed: () {
                                            final SearchCityController
                                                searchCtrl = Get.find();
                                            searchCtrl
                                                .fetchHotelImages(hotelId);
                                          },
                                          color: Colors.black.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: CommonTextWidget.PoppinsMedium(
                                            text: "View All",
                                            color: white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding:
                                EdgeInsets.only(left: 24, right: 24, top: 55),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(
                                      internationalDetailBackImage),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => HotelDetailSearchScreen());
                                      },
                                      child: SvgPicture.asset(
                                          internationalDetailSearchImage),
                                    ),
                                    SizedBox(width: 20),
                                    SvgPicture.asset(hotelDetailHeartIcon),
                                    SizedBox(width: 20),
                                    MaterialButton(
                                      onPressed: () {
                                        final SearchCityController searchCtrl =
                                            Get.find();
                                        searchCtrl.fetchHotelImages(hotelId);
                                      },
                                      color: Colors.black.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: CommonTextWidget.PoppinsMedium(
                                        text: "View All",
                                        color: white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                  // Hotel Name, Address, Rating, Dates, Guests
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
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
                                    text: hotelDetail['HotelAddress']
                                            ?['City'] ??
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
                                hotelDetail['HotelAddress']?['Longitude'] !=
                                    null)
                              InkWell(
                                onTap: () {
                                  final lat =
                                      hotelDetail['HotelAddress']?['Latitude'];
                                  final lng =
                                      hotelDetail['HotelAddress']?['Longitude'];
                                  // Example: launch Google Maps
                                  // launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'));
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
                            // Show stars according to rating
                            ...List.generate(
                              rating.floor(),
                              (index) => Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                            ),
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
                              Icon(Icons.calendar_today,
                                  size: 16, color: redCA0),
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
                                // "6 Jul - 8 Jul",
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
                              // Modify icon/button
                              InkWell(
                                onTap: () {
                                  // Implement modify logic, e.g., open date/guest selection
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
                  SizedBox(height: 7),
                  Divider(color: greyE8E, thickness: 1),
                  // Reviews section placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          "“Great location, clean rooms, friendly staff.”",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: grey717),
                        ),
                        // Add a button to view all reviews if desired
                      ],
                    ),
                  ),
                  // Room List - modern card design
                  if (hotelRooms.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "Rooms",
                            color: black2E2,
                            fontSize: 19,
                          ),
                          ...hotelRooms.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final room = entry.value;
                            final roomName = room['Name'] ?? '';
                            final imageUrl = room['Image']?['ImageUrl'] ?? '';
                            final description = room['Description'] ?? '';
                            // Map HotelRooms to HotelServices by index
                            String price = hotelServicePrice;
                            if (hotelServices != null &&
                                hotelServices.length > idx &&
                                hotelServices[idx]['ServicePrice'] != null) {
                              price =
                                  hotelServices[idx]['ServicePrice'].toString();
                            } else if (room['HotelServices'] != null &&
                                room['HotelServices'] is List &&
                                (room['HotelServices'] as List).isNotEmpty &&
                                room['HotelServices'][0]['ServicePrice'] !=
                                    null) {
                              price = room['HotelServices'][0]['ServicePrice']
                                  .toString();
                            }
                            final taxes = room['TaxesAndFees']?.toString() ??
                                hotelDetail['TaxesAndFees']?.toString() ??
                                '0';
                            final amenities =
                                room['Amenities'] as List<dynamic>? ?? [];

                            // Split description into points (assuming separated by . or \n)
                            final List<String> descPoints = description
                                .replaceAll(RegExp(r'<[^>]*>'), '')
                                .split(RegExp(r'[.\n]'))
                                .map((e) => e.trim())
                                .where((e) => e is String && e.isNotEmpty)
                                .cast<String>()
                                .toList();

                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: greyE8E, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          width: double.infinity,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: double.infinity,
                                            height: 150,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 14, 16, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.king_bed_rounded,
                                                  color: redCA0, size: 20),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  roomName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: black2E2,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          if (descPoints.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...descPoints
                                                    .take(3)
                                                    .map((point) => Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("• ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color:
                                                                        grey717)),
                                                            Expanded(
                                                              child: Text(
                                                                point,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      grey717,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                if (descPoints.length > 3)
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          18)),
                                                        ),
                                                        builder: (ctx) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(roomName,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18)),
                                                                SizedBox(
                                                                    height: 10),
                                                                if (imageUrl
                                                                    .isNotEmpty)
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child: Image.network(
                                                                        imageUrl,
                                                                        height:
                                                                            160,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                SizedBox(
                                                                    height: 14),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children:
                                                                      descPoints
                                                                          .map((point) =>
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text("• ", style: TextStyle(fontSize: 13, color: grey717)),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      point,
                                                                                      style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        color: grey717,
                                                                                        fontFamily: 'Poppins',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                          .toList(),
                                                                ),
                                                                SizedBox(
                                                                    height: 14),
                                                                if (amenities
                                                                    .isNotEmpty)
                                                                  Wrap(
                                                                    spacing: 8,
                                                                    runSpacing:
                                                                        8,
                                                                    children: amenities
                                                                        .map((a) => Chip(
                                                                              label: Text(a.toString(), style: TextStyle(fontSize: 12)),
                                                                              backgroundColor: greyE8E,
                                                                            ))
                                                                        .toList(),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0,
                                                              top: 2.0),
                                                      child: Text(
                                                        "More",
                                                        style: TextStyle(
                                                          color: redCA0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          SizedBox(height: 10),
                                          if (amenities.isNotEmpty)
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: amenities
                                                  .take(4)
                                                  .map((a) => Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: greyE8E,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .check_circle,
                                                                size: 13,
                                                                color: redCA0),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              a.toString(),
                                                              style: TextStyle(
                                                                color: black2E2,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "₹ $price",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          19, // More prominent
                                                      color:
                                                          redCA0, // Highlighted color
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "+ ₹$taxes taxes & fees",
                                                    style: TextStyle(
                                                      color: grey717,
                                                      fontSize: 11,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Offer badge example
                                              if (room['Offer'] != null)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    room['Offer'],
                                                    style: TextStyle(
                                                      color: Colors.green[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                        color: greyE8E,
                                        height: 1,
                                        thickness: 1),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.to(
                                                () => RatePlanDetailScreen());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: redCA0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            "SELECT",
                                            style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }).toList(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Sticky action bar for "SELECT ROOM"
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: black2E2,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: "₹ ${hotelServicePrice}",
                        color: white,
                        fontSize: 16,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text:
                            "+ ₹${hotelDetail['TaxesAndFees']?.toString() ?? '0'} taxes & service fees",
                        color: white,
                        fontSize: 10,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text:
                            "Per Night (${hotelDetail['Guests']?.toString() ?? '2 Adults'})",
                        color: white,
                        fontSize: 10,
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => RatePlanDetailScreen());
                    },
                    height: 40,
                    minWidth: 140,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: redCA0,
                    child: CommonTextWidget.PoppinsSemiBold(
                      fontSize: 16,
                      text: "SELECT ROOM",
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
