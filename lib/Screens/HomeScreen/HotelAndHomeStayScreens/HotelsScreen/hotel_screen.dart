import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/gallery_view.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_and_homestay.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class HotelScreen extends GetView<SearchCityController> {
  final String cityId;
  final String cityName;
  final Map<String, dynamic> hotelDetails;

  HotelScreen({
    Key? key,
    required this.cityId,
    required this.cityName,
    required this.hotelDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchCityController searchCtrl = Get.find();
    final hotels = List<Map<String, dynamic>>.from(hotelDetails['Hotels'] ?? []);
    final checkInDate = searchCtrl.checkInDate.value;
    final checkOutDate = searchCtrl.checkOutDate.value;
    final dateRange = checkInDate != null && checkOutDate != null
        ? "${checkInDate.day} ${_getMonthName(checkInDate.month)} - ${checkOutDate.day} ${_getMonthName(checkOutDate.month)}"
        : "";
    final roomCount = searchCtrl.roomsCount.value;
    final adultCount = searchCtrl.adultsCount.value;
    final childCount = searchCtrl.childrenCount.value;
    final guestInfo =
        "$roomCount Room, $adultCount Adults${childCount > 0 ? ', $childCount Children' : ''}";

    return Scaffold(
      backgroundColor: redF9E,
      body: Stack(
        children: [
          Column(
            children: [
              // Print the incoming data for debugging
              Builder(
                builder: (context) {
                  // Print all HotelProviderSearchId values for debugging
                  if (hotelDetails['Hotels'] != null && hotelDetails['Hotels'].isNotEmpty) {
                    print('HotelProviderSearchId: ${hotelDetails['Hotels'][0]['HotelProviderSearchId']}');
                  }
                  print('cityId: $cityId');
                  print('cityName: $cityName');
                  print('hotelDetails: $hotelDetails');
                  return SizedBox.shrink();
                },
              ),
              Container(
                height: 155,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(hotelAndHomeStayTopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            horizontalTitleGap: -5,
                            leading: InkWell(
                              onTap: () => Get.back(),
                              child: Icon(Icons.arrow_back, color: grey888, size: 20),
                            ),
                            title: CommonTextWidget.PoppinsMedium(
                              text: cityName,
                              color: black2E2,
                              fontSize: 15,
                            ),
                            subtitle: CommonTextWidget.PoppinsRegular(
                              text: "$dateRange, $guestInfo",
                              color: grey717,
                              fontSize: 12,
                            ),
                            trailing: InkWell(
                              onTap: () => Get.to(() => HotelAndHomeStay()),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(draw),
                                  SizedBox(height: 10),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Edit",
                                    color: redCA0,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on, color: redCA0),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Map",
                                    color: redCA0,
                                    fontSize: 12,
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
              ),
              Container(
                height: 50,
                width: Get.width,
                color: white,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 24, right: 19, top: 1, bottom: 10),
                  shrinkWrap: true,
                  itemCount: Lists.hotelList1.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: Lists.hotelList1[index]["onTap"],
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: white,
                          border: Border.all(color: greyE2E, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: Row(
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.hotelList1[index]["text"],
                                color: grey717,
                                fontSize: 12,
                              ),
                              SizedBox(width: 7),
                              SvgPicture.asset(arrowDownIcon, color: grey717),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: hotels.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hotel_outlined, size: 48, color: grey717.withOpacity(0.5)),
                            SizedBox(height: 16),
                            Text(
                              'No hotels found for these dates',
                              style: TextStyle(
                                fontSize: 16,
                                color: grey717,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: hotels.length,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        itemBuilder: (context, index) {
                          final hotel = hotels[index];
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
                                            color: white,
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
                        },
                      ),
              ),
            ],
          ),
          // Screen loader overlay
          Obx(() => searchCtrl.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: redCA0,
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _getHotelPrice(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePrice'] != null) {
      return hotel['HotelServices'][0]['ServicePrice'].toString();
    }
    return hotel['MinPrice']?.toString() ?? '0';
  }

  bool _hasDiscount(Map<String, dynamic> hotel) {
    return hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] > 0;
  }

  String _getOriginalPrice(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null) {
      return hotel['HotelServices'][0]['ServicePriceBeforePromotion'].toString();
    }
    return hotel['MinPrice']?.toString() ?? '0';
  }

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
                              Icon(Icons.photo_library, color: white, size: 20),
                              SizedBox(height: 4),
                              CommonTextWidget.PoppinsMedium(
                                text: '+${images.length - 3}',
                                color: white,
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

  Widget _buildRatingBadge(Map<String, dynamic> hotel) {
    final rating = hotel['StarRating'];
    if (rating == null) return SizedBox();
    final double starRating = rating is String
        ? double.tryParse(rating) ?? 0.0
        : (rating as num).toDouble();
    if (starRating <= 0) return SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: redCA0,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: white, size: 16),
          SizedBox(width: 4),
          Text(
            starRating.toStringAsFixed(1),
            style: TextStyle(
              color: white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDiscount(Map<String, dynamic> hotel) {
    if (hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null &&
        hotel['HotelServices'][0]['ServicePrice'] != null) {
      final originalPrice = hotel['HotelServices'][0]['ServicePriceBeforePromotion'];
      final discountedPrice = hotel['HotelServices'][0]['ServicePrice'];
      final discount = ((originalPrice - discountedPrice) / originalPrice * 100).round();
      return discount;
    }
    return 0;
  }
}
