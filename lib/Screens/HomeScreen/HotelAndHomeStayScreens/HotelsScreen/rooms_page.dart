import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/booking_preview_page.dart';
import 'package:flutter_html/flutter_html.dart';


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
                  margin: EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
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
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: 150,
                              color: Colors.grey[300],
                              child: Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.king_bed_rounded, color: redCA0, size: 20),
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
                                    overflow: TextOverflow.ellipsis,
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
                            if (amenities.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: amenities.take(4).map((a) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, size: 13, color: redCA0),
                                      SizedBox(width: 4),
                                      Text(
                                        a.toString(),
                                        style: TextStyle(
                                          color: black2E2,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )).toList(),
                              ),
                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹ $price",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        color: redCA0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      "+ ₹$taxes taxes & fees",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 11,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                if (room['Offer'] != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      room['Offer'],
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
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
                      Divider(color: Colors.grey[200], height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                            child: Text(
                              "Reserve 1 Room",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
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
