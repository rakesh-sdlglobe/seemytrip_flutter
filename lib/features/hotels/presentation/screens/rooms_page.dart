// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
            return _buildShimmerEffect(height: height, context: context);
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
                  _buildErrorWidget(height: height, context: context),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildShimmerEffect(height: height, context: context);
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
                _buildShimmerEffect(height: height, context: context),
            errorWidget: (BuildContext context, String url, Object error) =>
                _buildErrorWidget(height: height, context: context),
          );
        },
      );

  Widget _buildShimmerEffect({required double height, required BuildContext context}) => Shimmer.fromColors(
        baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: height,
          color: Theme.of(context).cardColor,
        ),
      );

  Widget _buildErrorWidget({required double height, required BuildContext context}) => Container(
        width: double.infinity,
        height: height,
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.broken_image, size: 40, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
            SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
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
        title: Text('Select Room', style: TextStyle(color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: hotelRooms.isEmpty
          ? Center(
              child: Text(
                'No rooms available',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodySmall?.color),
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
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.03),
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Theme.of(context).dividerColor),
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
                                    color: Theme.of(context).brightness == Brightness.dark
                                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                                      : Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.king_bed_rounded,
                                      color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).primaryColor.withOpacity(0.9)
                                        : Theme.of(context).primaryColor, size: 20),
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
                                          color: Theme.of(context).textTheme.titleLarge?.color,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${searchParams['adults'] ?? 2} Adults • ${searchParams['rooms'] ?? 1} Room',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).textTheme.bodySmall?.color,
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
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "strong": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleMedium?.color,
                                    ),
                                    "b": Style(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleMedium?.color,
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
                                  color: Theme.of(context).textTheme.titleMedium?.color,
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
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey[800]
                                              : Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.grey[700]!
                                                  : Colors.grey[200]!),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.check_circle,
                                                  size: 14,
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                    ? const Color(0xFFFF5722) // Orange-red for dark theme
                                                    : const Color(0xFFCA0B0B)), // Red for light theme
                                              SizedBox(width: 6),
                                              Text(
                                                a.toString(),
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
                                color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[50],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[700]!
                                  : Colors.grey[100]!),
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
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? const Color(0xFFFF5722) // Orange-red for dark theme
                                              : const Color(0xFFCA0B0B), // Red for light theme
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(text: '₹$price '),
                                            TextSpan(
                                              text: 'per night',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).textTheme.bodySmall?.color,
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
                                          color: Theme.of(context).textTheme.bodySmall?.color,
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
                                        color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.green[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.green.withOpacity(0.3)
                                              : Colors.green[100]!),
                                      ),
                                      child: Text(
                                        room['Offer'],
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.green[300]
                                            : Colors.green[800],
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
                      Divider(color: Theme.of(context).dividerColor, height: 1, thickness: 1),
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
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '₹${(double.tryParse(price) ?? 0) + (double.tryParse(taxes) ?? 0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).textTheme.titleLarge?.color,
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
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFFFF5722) // Orange-red for dark theme
                                    : const Color(0xFFCA0B0B), // Red for light theme
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
