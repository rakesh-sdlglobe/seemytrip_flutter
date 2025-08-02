// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'booking_preview_page.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
    Key? key,
  }) : super(key: key);
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  // Load image from cache or network
  Widget _buildCachedImage(String imageUrl, {double height = 150}) =>
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return _buildShimmerEffect(height: height);
          }

          final SharedPreferences prefs = snapshot.data!;
          final String? cachedImage =
              prefs.getString('cached_image_${Uri.encodeComponent(imageUrl)}');

          if (cachedImage != null) {
            return Image.network(
              cachedImage,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) =>
                  _buildErrorWidget(height: height),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
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
            placeholder: (BuildContext context, String url) =>
                _buildShimmerEffect(height: height),
            errorWidget: (BuildContext context, String url, Object error) =>
                _buildErrorWidget(height: height),
          );
        },
      );

  Widget _buildShimmerEffect({required double height}) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: height,
          color: AppColors.surface,
        ),
      );

  Widget _buildErrorWidget({required double height}) => Container(
        width: double.infinity,
        height: height,
        color: AppColors.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
            SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final hotelDetail = hotelDetails['HotelDetail'] ?? <dynamic, dynamic>{};
    final List<Map<String, dynamic>> hotelRooms =
        List<Map<String, dynamic>>.from(
            hotelDetail['HotelRooms'] ?? <dynamic>[]);
    final List? hotelServices = hotelDetail['HotelServices'] as List<dynamic>?;
    final String hotelServicePrice = hotelServices != null &&
            hotelServices.isNotEmpty &&
            hotelServices[0]['ServicePrice'] != null
        ? hotelServices[0]['ServicePrice'].toString()
        : hotelDetail['Price']?.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Room', style: TextStyle(color: AppColors.surface)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.surface),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.surface,
      body: hotelRooms.isEmpty
          ? Center(
              child: Text(
                'No rooms available',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: hotelRooms.length,
              itemBuilder: (BuildContext context, int idx) {
                final Map<String, dynamic> room = hotelRooms[idx];
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
                final String taxes = room['TaxesAndFees']?.toString() ??
                    hotelDetail['TaxesAndFees']?.toString() ??
                    '0';
                final List amenities =
                    room['Amenities'] as List<dynamic>? ?? <dynamic>[];

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
                    boxShadow: <BoxShadow>[
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
                    children: <Widget>[
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
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.king_bed_rounded,
                                      color: AppColors.primary, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        roomName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: AppColors.textPrimary,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${searchParams['adults'] ?? 2} Adults • ${searchParams['rooms'] ?? 1} Room',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
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
                                  style: <String, Style>{
                                    "body": Style(
                                      fontSize: FontSize(13),
                                      fontFamily: 'Poppins',
                                      color: AppColors.textSecondary,
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "strong": Style(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    "b": Style(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  },
                                ),
                              ),
                            SizedBox(height: 8),
                            if (amenities.isNotEmpty) ...<Widget>[
                              SizedBox(height: 16),
                              Text(
                                'Room Amenities',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: amenities
                                    .take(4)
                                    .map((a) => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey[200]!),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.check_circle,
                                                  size: 14,
                                                  color: AppColors.primary),
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
                                        ))
                                    .toList(),
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
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Starting from',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(text: '₹$price '),
                                            TextSpan(
                                              text: 'per night',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
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
                                          color: AppColors.textSecondary,
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
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Total for your stay',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '₹${(double.tryParse(price) ?? 0) + (double.tryParse(taxes) ?? 0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Parse price and taxes to double before passing to BookingPreviewPage
                                  // Inside the ElevatedButton's onPressed callback

                                  // 1. Parse the string variables into doubles.
                                  // The .replaceAll() is a great defensive move to strip non-numeric characters like '₹'.
                                  final double parsedPrice = double.tryParse(
                                          price.replaceAll(
                                              RegExp(r'[^\d.]'), '')) ??
                                      0.0;
                                  final double parsedTaxes = double.tryParse(
                                          taxes.replaceAll(
                                              RegExp(r'[^\d.]'), '')) ??
                                      0.0;

                                  // 2. Pass the parsed double values to the next page.
                                  Get.to(() => BookingPreviewPage(
                                        hotelDetails: hotelDetails,
                                        hotelId: hotelId,
                                        searchParams: searchParams,
                                        selectedRoom: room,
                                        price: parsedPrice, // Now a double ✅
                                        taxes: parsedTaxes, // Now a double ✅
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.surface,
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
