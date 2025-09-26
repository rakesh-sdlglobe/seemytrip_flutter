import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/widgets/common_text_widget.dart';
import '../../../../shared/constants/images.dart';
import '../controllers/hotel_controller.dart';
import '../screens/hotel_detail_search_screen.dart';

class HotelImagesAppBar extends StatefulWidget {

  const HotelImagesAppBar({
    required this.images, required this.hotelId, required this.isFavorite, required this.onFavoritePressed, Key? key,
  }) : super(key: key);
  final List<dynamic>? images;
  final String hotelId;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  
  

  @override
  State<HotelImagesAppBar> createState() => _HotelImagesAppBarState();
}

class _HotelImagesAppBarState extends State<HotelImagesAppBar> {
  int _currentPage = 0;
  final bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final List images = widget.images ?? <dynamic>[];
    return Container(
      height: 250,
      width: Get.width,
      decoration: BoxDecoration(
        image: images.isNotEmpty
            ? null
            : DecorationImage(
                image: AssetImage(hotelDetailTopImage),
                fit: BoxFit.fill,
              ),
      ),
      child: images.isNotEmpty
          ? Stack(
              children: <Widget>[
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (int i) => setState(() => _currentPage = i),
                  itemBuilder: (BuildContext context, int index) => Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
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
                        images.length,
                        (int dotIndex) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == dotIndex
                                ? AppColors.redCA0
                                : AppColors.white.withValues(alpha: 0.8),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(internationalDetailBackImage),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Get.to(() => HotelDetailSearchScreen());
                            },
                            child: SvgPicture.asset(internationalDetailSearchImage),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: widget.onFavoritePressed,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          MaterialButton(
                            onPressed: () {
                              final SearchCityController searchCtrl = Get.find()
                              ..fetchHotelImages(widget.hotelId);
                            },
                            color: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: CommonTextWidget.PoppinsMedium(
                              text: 'View All',
                              color: Colors.white,
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
              padding: EdgeInsets.only(left: 24, right: 24, top: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(internationalDetailBackImage),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Get.to(() => HotelDetailSearchScreen());
                        },
                        child: SvgPicture.asset(internationalDetailSearchImage),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          widget.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.redCA0,
                        ),
                      ),
                      SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          final SearchCityController searchCtrl = Get.find()
                          ..fetchHotelImages(widget.hotelId);
                        },
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CommonTextWidget.PoppinsMedium(
                          text: 'View All',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
