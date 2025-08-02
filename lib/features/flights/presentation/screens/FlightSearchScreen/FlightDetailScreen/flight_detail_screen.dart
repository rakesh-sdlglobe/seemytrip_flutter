import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_detail_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/FlightDetailScreen/FlightDetailScreen1/flight_detail_screen1.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class FlightDetailScreen extends StatelessWidget {
  FlightDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Flight Details",
          color: white,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.close, color: white, size: 20),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, left: 24, right: 24),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: AssetImage(flightDetailImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 12),
                              child: Column(
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: "DEL - BOM",
                                    color: white,
                                    fontSize: 18,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Non stop | 2 hrs 15 mins | Economy",
                                    color: white,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 15, left: 15, right: 15, bottom: 18),
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
                                      text: "SpiceJet  | SG8169",
                                      color: black2E2,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: "19.45",
                                      color: black2E2,
                                      fontSize: 20,
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: "-- 2 hrs 15 mins --",
                                      color: black2E2,
                                      fontSize: 12,
                                    ),
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: "22.00",
                                      color: black2E2,
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget.PoppinsRegular(
                                      text: "Sat, 24 Sep 22",
                                      color: black2E2,
                                      fontSize: 12,
                                    ),
                                    SvgPicture.asset(watch),
                                    CommonTextWidget.PoppinsRegular(
                                      text: "Sat, 24 Sep 22",
                                      color: black2E2,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget.PoppinsMedium(
                                          text: "New Delhi",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "Indira Gandhi",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "International Airport",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "Terminal 3",
                                          color: grey717,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CommonTextWidget.PoppinsMedium(
                                          text: "Mumbai",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "Chhatrapati Shivaji",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "International Airport",
                                          color: black2E2,
                                          fontSize: 12,
                                        ),
                                        CommonTextWidget.PoppinsRegular(
                                          text: "Terminal 2",
                                          color: grey717,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GetBuilder<FlightDetailController>(
                      init: FlightDetailController(),
                      builder: (controller) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: Lists.flightBookTicketDetailList.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 8),
                        itemBuilder: (context, index) => Padding(
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
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                controller.onIndexChange(index);
                                              },
                                              child: Container(
                                                height: 18,
                                                width: 18,
                                                decoration: BoxDecoration(
                                                    color: white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: controller
                                                                    .selectedIndex ==
                                                                index
                                                            ? redCA0
                                                            : grey717)),
                                                alignment: Alignment.center,
                                                child: controller
                                                            .selectedIndex ==
                                                        index
                                                    ? Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: redCA0,
                                                                shape: BoxShape
                                                                    .circle),
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonTextWidget
                                                    .PoppinsSemiBold(
                                                  text: Lists
                                                          .flightBookTicketDetailList[
                                                      index]["text1"],
                                                  color: black2E2,
                                                  fontSize: 14,
                                                ),
                                                CommonTextWidget.PoppinsRegular(
                                                  text:
                                                      "Fare offered by airline.",
                                                  color: grey717,
                                                  fontSize: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        CommonTextWidget.PoppinsSemiBold(
                                          text:
                                              Lists.flightBookTicketDetailList[
                                                  index]["text2"],
                                          color: black2E2,
                                          fontSize: 16,
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
                                              child:
                                                  SvgPicture.asset(briefcase),
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
                                              padding:
                                                  EdgeInsets.only(right: 10),
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
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              width: Get.width,
              color: black2E2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CommonTextWidget.PoppinsSemiBold(
                          text: "₹ 5,950",
                          color: white,
                          fontSize: 16,
                        ),
                        CommonTextWidget.PoppinsMedium(
                          text: "FOR 1 ADULT",
                          color: white,
                          fontSize: 10,
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.to(() => FlightDetailScreen1());
                      },
                      height: 40,
                      minWidth: 140,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: redCA0,
                      child: CommonTextWidget.PoppinsSemiBold(
                        fontSize: 16,
                        text: "CONTINUE",
                        color: white,
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
}
