// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/utils/colors.dart';
import '../controllers/hotel_controller.dart';
import '../screens/gallery_view.dart';

// Colors
const Color _redCA0 = Color(0xFFCA0B0B);
const Color _grey717 = Color(0xFF717171);
const Color _greyE2E = Color(0xFFE2E2E2);

// Text Styles
TextStyle _poppinsMedium({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: fontSize ?? 14,
    color: color ?? Colors.black87,
  );

TextStyle _poppinsBold({double? fontSize, Color? color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: fontSize ?? 16,
    color: color ?? Colors.black87,
  );


class HotelListCard extends StatefulWidget {
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
  State<HotelListCard> createState() => _HotelListCardState();
}

class _HotelListCardState extends State<HotelListCard> with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        // Handle hotel tap
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image with Favorite Button
            Stack(
              children: [
                // Hotel Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildHotelImage(widget.hotel),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                      if (isFavorited) {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                      } else {
                        _animationController.reverse();
                      }
                      // TODO: Add your favorite logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? _redCA0 : _redCA0.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Hotel Info
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 0), // Adjusted padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel Name
                      Expanded(
                        child: Text(
                          widget.hotel['HotelName'] ?? 'Unknown Hotel',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Star Rating
                      const SizedBox(width: 8),
                      _buildStarRating(widget.hotel['StarRating']),
                    ],
                  ),

                  // Location
                  const SizedBox(height: 8),
                  _buildLocationInfo(widget.hotel, widget.cityName),

                  // Price
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Starting from',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${_getHotelPrice(widget.hotel)}',
                        style: const TextStyle(
                          color: _redCA0,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cancellation Policy and Book Button
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 12, 16, 16), // Adjusted padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      widget.hotel['CancellationPolicy'] ?? 'Free Cancellation',
                      style: _poppinsMedium(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.searchCtrl.isLoading.value
                        ? null
                        : () async {
                            final searchParams = {
                              'cityId': widget.cityId,
                              'checkInDate': widget.searchCtrl.checkInDate.value
                                  ?.toIso8601String()
                                  .split('T')[0],
                              'checkOutDate': widget
                                  .searchCtrl.checkOutDate.value
                                  ?.toIso8601String()
                                  .split('T')[0],
                              'Rooms':
                                  widget.searchCtrl.roomsCount.value.toString(),
                              'adults': widget.searchCtrl.adultsCount.value
                                  .toString(),
                              'children': widget.searchCtrl.childrenCount.value
                                  .toString(),
                            };
                            widget.searchCtrl.isLoading.value = true;
                            try {
                              await widget.searchCtrl
                                  .fetchHotelDetailsWithPrice(
                                hotelId: widget.hotel['HotelProviderSearchId']
                                    .toString(),
                                searchParams: searchParams,
                              );
                            } finally {
                              widget.searchCtrl.isLoading.value = false;
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _redCA0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'See Availability',
                      style: _poppinsMedium(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  // --- Helper methods below (copy from your main file, or refactor as needed) ---
  Widget _buildHotelImage(Map<String, dynamic> hotel) {
    final images = List<String>.from(hotel['HotelImages'] ?? []);
    final imageUrl = images.isNotEmpty ? images.first : null;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: imageUrl == null || imageUrl.isEmpty
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel, size: 40, color: grey717),
                  const SizedBox(height: 8),
                  Text(
                    'No Image Available',
                    style: TextStyle(
                        color: grey717, fontSize: 12, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (BuildContext context, String url) => Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              errorWidget: (BuildContext context, String url, Object error) => Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.grey),
                ),
              ),
            ),
    );
  }

  Widget _buildThumbnailGallery(
      BuildContext context, Map<String, dynamic> hotel) {
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
                    onTap: () =>
                        _showImageGallery(context, images, images.indexOf(url)),
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
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: LoadingAnimationWidget.dotsTriangle(
                              color: redCA0,
                              size: 24,
                            ));
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
                              Icon(Icons.photo_library,
                                  color: Colors.white, size: 20),
                              SizedBox(height: 4),
                              Text(
                                '+${images.length - 3}',
                                style: _poppinsMedium(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
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

  void _showImageGallery(
      BuildContext context, List<String> images, int initialIndex) {
    Get.to(() => GalleryView(
          images: images,
          initialIndex: initialIndex,
        ));
  }

  Widget _buildStarRating(dynamic rating) {
    // Convert rating to double, defaulting to 0.0 if conversion fails
    final double starRating = rating is num 
        ? rating.toDouble() 
        : double.tryParse(rating.toString()) ?? 0.0;
        
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

  bool _hasDiscount(Map<String, dynamic> hotel) => hotel['HotelServices'] != null &&
        hotel['HotelServices'].isNotEmpty &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] != null &&
        hotel['HotelServices'][0]['ServicePriceBeforePromotion'] > 0;

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
      return hotel['HotelServices'][0]['ServicePriceBeforePromotion']
          .toString();
    }
    return hotel['MinPrice']?.toString() ?? '0';
  }
}
