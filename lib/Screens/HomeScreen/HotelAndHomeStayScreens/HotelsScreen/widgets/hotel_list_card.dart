import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/gallery_view.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';

class HotelListCard extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final String cityName;
  final String cityId;
  final SearchCityController searchCtrl;

  const HotelListCard({
    Key? key,
    required this.hotel,
    required this.cityName,
    required this.cityId,
    required this.searchCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _buildHotelImage(hotel),
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildThumbnailGallery(context, hotel),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: hotel['HotelName'] ?? 'Unknown Hotel',
                              color: black2E2,
                              fontSize: 16,
                            ),
                          ),
                          _buildStarRating(hotel['StarRating']),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildLocationInfo(hotel, cityName),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsRegular(
                                text: 'Starting from',
                                color: grey717,
                                fontSize: 12,
                              ),
                              if (_hasDiscount(hotel))
                                Text(
                                  '₹${_getOriginalPrice(hotel)}',
                                  style: TextStyle(
                                    color: grey717,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                            ],
                          ),
                          CommonTextWidget.PoppinsBold(
                            text: '₹${_getHotelPrice(hotel)}',
                            color: redCA0,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: CommonTextWidget.PoppinsMedium(
                      text: hotel['CancellationPolicy'] ?? 'Free Cancellation',
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: searchCtrl.isLoading.value
                        ? null
                        : () async {
                            final searchParams = {
                              'cityId': cityId,
                              'checkInDate': searchCtrl.checkInDate.value?.toIso8601String().split('T')[0],
                              'checkOutDate': searchCtrl.checkOutDate.value?.toIso8601String().split('T')[0],
                              'Rooms': searchCtrl.roomsCount.value.toString(),
                              'adults': searchCtrl.adultsCount.value.toString(),
                              'children': searchCtrl.childrenCount.value.toString(),
                            };
                            searchCtrl.isLoading.value = true;
                            try {
                              await searchCtrl.fetchHotelDetailsWithPrice(
                                hotelId: hotel['HotelProviderSearchId'].toString(),
                                searchParams: searchParams,
                              );
                            } finally {
                              searchCtrl.isLoading.value = false;
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redCA0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CommonTextWidget.PoppinsMedium(
                      text: 'See Availability',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper methods below (copy from your main file, or refactor as needed) ---
  Widget _buildHotelImage(Map<String, dynamic> hotel) {
    final images = List<String>.from(hotel['HotelImages'] ?? []);
    final imageUrl = images.isNotEmpty ? images.first : null;
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hotel, size: 40, color: grey717),
              SizedBox(height: 8),
              CommonTextWidget.PoppinsRegular(
                text: 'No image available',
                color: grey717,
                fontSize: 12,
              ),
            ],
          ),
        ),
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(Icons.error_outline, color: grey717),
        ),
      ),
    );
  }

  Widget _buildThumbnailGallery(BuildContext context, Map<String, dynamic> hotel) {
    final images = List<String>.from(hotel['HotelImages'] ?? []);
    if (images.isEmpty) return SizedBox();
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          ...images.take(3).map((url) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => _showImageGallery(context, images, images.indexOf(url)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: greyE2E),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          url,
                          height: 70,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: grey717),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          if (images.length > 3)
            Expanded(
              child: InkWell(
                onTap: () => _showImageGallery(context, images, 3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: greyE2E),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          images[3],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: grey717),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library, color: Colors.white, size: 20),
                              SizedBox(height: 4),
                              CommonTextWidget.PoppinsMedium(
                                text: '+${images.length - 3}',
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showImageGallery(BuildContext context, List<String> images, int initialIndex) {
    Get.to(() => GalleryView(
          images: images,
          initialIndex: initialIndex,
        ));
  }

  Widget _buildStarRating(dynamic rating) {
    if (rating == null) return SizedBox();
    final double starRating = rating is String
        ? double.tryParse(rating) ?? 0.0
        : (rating as num).toDouble();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text(
          starRating.toStringAsFixed(1),
          style: TextStyle(
            color: black2E2,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(Map<String, dynamic> hotel, String cityName) {
    final location = hotel['Location'] ?? cityName;
    return Row(
      children: [
        Icon(Icons.location_on, size: 14, color: grey717),
        SizedBox(width: 4),
        Expanded(
          child: CommonTextWidget.PoppinsRegular(
            text: location,
            color: grey717,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  bool _hasDiscount(Map<String, dynamic> hotel) {
    return hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] > 0;
  }

  String _getHotelPrice(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePrice'] != null) {
      return hotel['HotelServices'][0]['ServicePrice'].toString();
    }
    return hotel['MinPrice']?.toString() ?? '0';
  }

  String _getOriginalPrice(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null) {
      return hotel['HotelServices'][0]['ServicePriceBeforePromotion'].toString();
    }
    return hotel['MinPrice']?.toString() ?? '0';
  }
}
