import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/holiday_package_slider_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/explore_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/holiday_package_detail_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/search_destination_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/start_from_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class HolidayPackagesScreen extends StatelessWidget {
  HolidayPackagesScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  final HolidayPackageSliderController holidayPackageSliderController =
      Get.put(HolidayPackageSliderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(holidayPackagesImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child:
                                Icon(Icons.arrow_back, color: white, size: 20),
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "New Delhi",
                            color: white,
                            fontSize: 18,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => StartFromSCreen());
                            },
                            child: CommonTextWidget.PoppinsMedium(
                              text: "City",
                              color: white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 70,
                    width: Get.width,
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        itemCount: Lists.holidayPackagesList1.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                            top: 13, bottom: 13, left: 24, right: 12),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => ExploreScreen(
                                    Lists.holidayPackagesList1[index]),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 6,
                                    color: grey515.withOpacity(0.25),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: CommonTextWidget.PoppinsMedium(
                                    text: Lists.holidayPackagesList1[index],
                                    color: grey5F5,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: "Best selling destinations",
                      color: black2E2,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsRegular(
                      text: "Grab best price for Oct-travel, Book now",
                      color: grey717,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 24, right: 9),
                      itemCount: Lists.holidayPackagesList2.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => HolidayPackageDetailScreen());
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                  Lists.holidayPackagesList2[index]["image"],
                                  height: 80,
                                  width: 80),
                              SizedBox(height: 10),
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.holidayPackagesList2[index]["text"],
                                color: black2E2,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 8),
                  CarouselSlider.builder(
                    itemCount: Lists.holidayPackageSliderList.length,
                    itemBuilder:
                        (BuildContext context, index, int pageViewIndex) =>
                            Container(
                      height: 200,
                      width: Get.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            Lists.holidayPackageSliderList[index],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        initialPage: 3,
                        viewportFraction: 0.98,
                        onPageChanged: (index, reason) {
                          holidayPackageSliderController.sliderIndex.value =
                              index;
                        }),
                  ),
                  SizedBox(height: 12),
                  Obx(
                    () => Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: i ==
                                          holidayPackageSliderController
                                              .sliderIndex.value
                                      ? redCA0
                                      : greyD3D,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: "Easy Visa Destinations",
                      color: black2E2,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsRegular(
                      text: "Now travel the world without any hassie!",
                      color: grey717,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 24, right: 14),
                      itemCount: Lists.holidayPackagesList3.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                  Lists.holidayPackagesList3[index]["image"],
                                  height: 100,
                                  width: 110),
                            ),
                            SizedBox(height: 10),
                            CommonTextWidget.PoppinsRegular(
                              text: "Starting at",
                              color: grey717,
                              fontSize: 12,
                            ),
                            CommonTextWidget.PoppinsSemiBold(
                              text: Lists.holidayPackagesList3[index]["text"],
                              color: black2E2,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: "Best selling destinations",
                      color: black2E2,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsRegular(
                      text: "Grab best price for Oct-travel, Book now",
                      color: grey717,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 24, right: 9),
                      itemCount: Lists.holidayPackagesList4.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Column(
                          children: [
                            Image.asset(
                                Lists.holidayPackagesList4[index]["image"],
                                height: 80,
                                width: 80),
                            SizedBox(height: 10),
                            CommonTextWidget.PoppinsMedium(
                              text: Lists.holidayPackagesList4[index]["text"],
                              color: black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 105, left: 24, right: 24),
                child: InkWell(
                  onTap: () {
                    Get.to(() => SearchDestinationScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          color: grey515.withOpacity(0.25),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.search, color: grey717),
                          SizedBox(width: 10),
                          CommonTextWidget.PoppinsRegular(
                            color: greyA1A,
                            text: "Search Destinations",
                            fontSize: 15,
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
    );
  }
}
