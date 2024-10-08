import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/FlightBookScreen/FlightSearchScreen/offer_make_your_trip_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/FlightBookScreen/flight_book_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class RoundTripScreen extends StatelessWidget {
  RoundTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: Lists.flightSearchRoundTripList1.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: Lists.flightSearchRoundTripList1[index]["onTap"],
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: grey9B9.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: greyE2E),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              Lists.flightSearchRoundTripList1[index]["image"]),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.flightSearchRoundTripList1[index]
                                      ["text1"],
                                  color: grey888,
                                  fontSize: 14,
                                ),
                                Row(
                                  children: [
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: Lists
                                              .flightSearchRoundTripList1[index]
                                          ["text2"],
                                      color: black2E2,
                                      fontSize: 18,
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: Lists
                                              .flightSearchRoundTripList1[index]
                                          ["text3"],
                                      color: grey888,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                CommonTextWidget.PoppinsRegular(
                                  text: Lists.flightSearchRoundTripList1[index]
                                      ["text4"],
                                  color: grey888,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: grey9B9.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: greyE2E),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Row(
                    children: [
                      SvgPicture.asset(user),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "TRAVELLERS & CLASS",
                            color: grey888,
                            fontSize: 14,
                          ),
                          Row(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: "1,",
                                color: black2E2,
                                fontSize: 18,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "TEconomy/Premium Economy",
                                color: grey888,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: "SPECIAL FARES (OPTIONAL)",
                color: grey888,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 70,
              width: Get.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: Lists.flightSearchList2.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: white,
                        border: Border.all(color: greyE2E, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CommonTextWidget.PoppinsMedium(
                            text: Lists.flightSearchList2[index],
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
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonButtonWidget.button(
                buttonColor: redCA0,
                onTap: () {
                  Get.to(() => FlightBookScreen());
                },
                text: "SEARCH FLIGHTS",
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: "OFFERS",
                    color: black2E2,
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "View All",
                        color: redCA0,
                        fontSize: 14,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, color: redCA0, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: greyDED, thickness: 1),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {
                  Get.to(() => OfferMakeYourTripScreen());
                },
                child: CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (context, index, realIndex) => Container(
                    height: 170,
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(flightSearchImage),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high)),
                  ),
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 170,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        // realStateController.sliderIndex.value = index;
                      }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: Get.width,
              color: redF9E,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text:
                          "Explore the cheapest flight from New Delhi to Mumbai",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    Row(
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "EXPLORE FARE CALENDAR",
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: redCA0, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
