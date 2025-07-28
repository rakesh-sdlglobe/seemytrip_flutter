import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/booking_preview_page.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RoomsPage extends StatelessWidget {
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  const RoomsPage({
    Key? key,
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
  }) : super(key: key);

  // Load image from cache or network
  Widget _buildCachedImage(String imageUrl, {double height = 150}) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildShimmerEffect(height: height);
        }

        final prefs = snapshot.data!;
        final cachedImage =
            prefs.getString('cached_image_${Uri.encodeComponent(imageUrl)}');

        if (cachedImage != null) {
          return Image.network(
            cachedImage,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(height: height),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildShimmerEffect(height: height);
            },
          );
        }

        // Cache the image URL for future use
        prefs.setString(
            'cached_image_${Uri.encodeComponent(imageUrl)}', imageUrl);

        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmerEffect(height: height),
          errorWidget: (context, url, error) =>
              _buildErrorWidget(height: height),
        );
      },
    );
  }

  Widget _buildShimmerEffect({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorWidget({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotelDetail = hotelDetails['HotelDetail'] ?? {};
    final hotelRooms = List<Map<String, dynamic>>.from(hotelDetail['HotelRooms'] ?? []);
    final hotelServices = hotelDetail['HotelServices'] as List<dynamic>?;
    final hotelServicePrice = hotelServices != null &&
            hotelServices.isNotEmpty &&
            hotelServices[0]['ServicePrice'] != null
        ? hotelServices[0]['ServicePrice'].toString()
        : hotelDetail['Price']?.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Room', style: TextStyle(color: Colors.white)),
        backgroundColor: redCA0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.white,
      body: hotelRooms.isEmpty
          ? Center(
              child: Text(
                'No rooms available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: hotelRooms.length,
              itemBuilder: (context, idx) {
                final room = hotelRooms[idx];
                final roomName = room['Name'] ?? '';
                final imageUrl = room['Image']?['ImageUrl'] ?? '';
                final description = room['Description'] ?? '';
                String price = hotelServicePrice;
                if (room['HotelServices'] != null &&
                    room['HotelServices'] is List &&
                    (room['HotelServices'] as List).isNotEmpty &&
                    room['HotelServices'][0]['ServicePrice'] != null) {
                  price = room['HotelServices'][0]['ServicePrice'].toString();
                } else if (hotelServices != null &&
                    hotelServices.length > idx &&
                    hotelServices[idx]['ServicePrice'] != null) {
                  price = hotelServices[idx]['ServicePrice'].toString();
                }
                final taxes = room['TaxesAndFees']?.toString() ?? hotelDetail['TaxesAndFees']?.toString() ?? '0';
                final amenities = room['Amenities'] as List<dynamic>? ?? [];

                final List<String> descPoints = description
                    .replaceAll(RegExp(r'<[^>]*>'), '')
                    .split(RegExp(r'[.\n]'))
                    .map((e) => e.trim())
                    .where((e) => e is String && e.isNotEmpty)
                    .cast<String>()
                    .toList();

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: _buildCachedImage(imageUrl),
                        ),
                      Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: redCA0.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.king_bed_rounded,
                                      color: redCA0, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        roomName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: Colors.black87,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${searchParams['adults'] ?? 2} Adults • ${searchParams['rooms'] ?? 1} Room',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (description != null &&
                                description.toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Html(
                                  data: description,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(13),
                                      fontFamily: 'Poppins',
                                      color: Colors.grey[700],
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "strong": Style(
                                      fontWeight: FontWeight.bold,
                                      color: black2E2,
                                    ),
                                    "b": Style(
                                      fontWeight: FontWeight.bold,
                                      color: black2E2,
                                    ),
                                  },
                                ),
                              ),
                            SizedBox(height: 8),
                            if (amenities.isNotEmpty) ...[
                              SizedBox(height: 16),
                              Text(
                                'Room Amenities',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: amenities.take(4).map((a) => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey[200]!),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                              Icon(Icons.check_circle,
                                                  size: 14, color: redCA0),
                                              SizedBox(width: 6),
                                      Text(
                                        a.toString(),
                                        style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )).toList(),
                              ),
                            ],
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey[100]!),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Starting from',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: redCA0,
                                          ),
                                          children: [
                                            TextSpan(text: '₹$price '),
                                            TextSpan(
                                              text: 'per night',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '+ ₹$taxes taxes & fees',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (room['Offer'] != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.green[100]!),
                                      ),
                                      child: Text(
                                        room['Offer'],
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey[200], height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.all(16)
                            .copyWith(top: 12, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total for your stay',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '₹${(double.tryParse(price) ?? 0) + (double.tryParse(taxes) ?? 0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => BookingPreviewPage(
                                        hotelDetails: hotelDetails,
                                        hotelId: hotelId,
                                        searchParams: searchParams,
                                        selectedRoom: room,
                                        price: price,
                                        taxes: taxes,
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: redCA0,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
