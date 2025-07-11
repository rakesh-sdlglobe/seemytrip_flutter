import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_search_screen.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelImagesAppBar extends StatefulWidget {
  final List<dynamic>? images;
  final String hotelId;

  const HotelImagesAppBar({
    Key? key,
    required this.images,
    required this.hotelId,
  }) : super(key: key);

  @override
  State<HotelImagesAppBar> createState() => _HotelImagesAppBarState();
}

class _HotelImagesAppBarState extends State<HotelImagesAppBar> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images ?? [];
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
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, color: Colors.grey),
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
                        images.length,
                        (dotIndex) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == dotIndex
                                ? redCA0
                                : Colors.white.withOpacity(0.8),
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
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(internationalDetailBackImage),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => HotelDetailSearchScreen());
                            },
                            child: SvgPicture.asset(internationalDetailSearchImage),
                          ),
                          SizedBox(width: 20),
                          SvgPicture.asset(hotelDetailHeartIcon),
                          SizedBox(width: 20),
                          MaterialButton(
                            onPressed: () {
                              final SearchCityController searchCtrl = Get.find();
                              searchCtrl.fetchHotelImages(widget.hotelId);
                            },
                            color: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: CommonTextWidget.PoppinsMedium(
                              text: "View All",
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
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(internationalDetailBackImage),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => HotelDetailSearchScreen());
                        },
                        child: SvgPicture.asset(internationalDetailSearchImage),
                      ),
                      SizedBox(width: 20),
                      SvgPicture.asset(hotelDetailHeartIcon),
                      SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          final SearchCityController searchCtrl = Get.find();
                          searchCtrl.fetchHotelImages(widget.hotelId);
                        },
                        color: Colors.black.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CommonTextWidget.PoppinsMedium(
                          text: "View All",
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
