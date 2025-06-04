import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/FlightBookScreen/FlightDetailScreen/flight_detail_screen.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class CheapestListScreen extends StatefulWidget {
  CheapestListScreen({Key? key}) : super(key: key);

  @override
  State<CheapestListScreen> createState() => _CheapestListScreenState();
}

class _CheapestListScreenState extends State<CheapestListScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemCount: Lists.cheapestList.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    Lists.cheapestList[index]["isSelected"] =
                        !Lists.cheapestList[index]["isSelected"];
                  });
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              spicejet,
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(width: 8),
                            CommonTextWidget.PoppinsMedium(
                              text: "SpiceJet",
                              color: black2E2,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: Lists.cheapestList[index]["text1"],
                                  color: black2E2,
                                  fontSize: 14,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "New Delhi",
                                  color: black2E2,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: Lists.cheapestList[index]["text2"],
                                    style: TextStyle(
                                      fontFamily: FontFamily.PoppinsMedium,
                                      fontSize: 12,
                                      color: grey717,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: Lists.cheapestList[index]
                                            ["text3"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily:
                                                FontFamily.PoppinsMedium,
                                            color: black2E2),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 3,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: redCA0.withOpacity(0.25),
                                  ),
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "Non Stop",
                                  color: grey717,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: Lists.cheapestList[index]["text4"],
                                  color: black2E2,
                                  fontSize: 14,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "Mumbai",
                                  color: black2E2,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: Lists.cheapestList[index]["text5"],
                                  color: black2E2,
                                  fontSize: 14,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "View Prices",
                                  color: redCA0,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 20,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: orangeFFB.withOpacity(0.25),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 14, color: redCA0),
                                SizedBox(width: 7),
                                CommonTextWidget.PoppinsRegular(
                                  text:
                                      "Use MMTBONUS and get FLAT Rs. 970 instant discount",
                                  color: black2E2,
                                  fontSize: 9,
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
              Lists.cheapestList[index]["isSelected"] == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: Lists.flightBookTicketDetailList.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 8),
                      itemBuilder: (context, index1) => Padding(
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonTextWidget.PoppinsSemiBold(
                                            text: Lists
                                                    .flightBookTicketDetailList[
                                                index1]["text1"],
                                            color: black2E2,
                                            fontSize: 14,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "Fare offered by airline.",
                                            color: grey717,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CommonTextWidget.PoppinsSemiBold(
                                            text: Lists
                                                    .flightBookTicketDetailList[
                                                index1]["text2"],
                                            color: black2E2,
                                            fontSize: 16,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "4 Seats left at this price",
                                            color: redCA0,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(1.5),
                                      1: FlexColumnWidth(4.5),
                                      2: FlexColumnWidth(6),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: SvgPicture.asset(briefcase),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Cabin bag",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "7 Kgs",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: SvgPicture.asset(backpack),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Check-in",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "15 Kgs",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child:
                                                SvgPicture.asset(currencyInr),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Cancellation",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text:
                                                "Cancellation fee starting ₹ 3,600",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: SvgPicture.asset(
                                                calendarPlus1,
                                                color: redCA0),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Date Change",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text:
                                                "Date Change fee starting ₹ 3,350",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: SvgPicture.asset(seat),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Seat",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "Free Seat available",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: SvgPicture.asset(dish),
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: "Meal",
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "Get complimentary",
                                            color: grey717,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  CommonButtonWidget.button(
                                    buttonColor: redCA0,
                                    onTap: () {
                                      Get.to(() => FlightDetailScreen());
                                    },
                                    text: "Book Now",
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
