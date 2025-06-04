import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/FlightBookScreen/flight_book_screen.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class RoundTripScreen1 extends StatelessWidget {
  RoundTripScreen1({Key? key}) : super(key: key);

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
            SizedBox(height: 12),
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
            SizedBox(height: 41),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonButtonWidget.button(
                buttonColor: redCA0,
                onTap: () {
                  Get.to(() => FlightBookScreen());
                },
                text: "MODIFY SEARCH",
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
