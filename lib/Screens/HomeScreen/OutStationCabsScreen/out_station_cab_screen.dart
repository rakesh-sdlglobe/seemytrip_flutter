import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/cab_search_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/OutStationCabsScreen/out_station_cab_from_to_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class OutStationCabScreen extends StatelessWidget {
  OutStationCabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Outstation Cabs",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: yellowF7C.withOpacity(0.35),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(info, color: yellowCE8),
                    SizedBox(width: 10),
                    CommonTextWidget.PoppinsRegular(
                      text: "Includes one pick up & drop",
                      color: yellowCE8,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: grey9B9.withOpacity(0.15),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyE2E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                child: Row(
                  children: [
                    SvgPicture.asset(arrowsLeftRight),
                    SizedBox(width: 10),
                    CommonTextWidget.PoppinsMedium(
                      text: "Travel",
                      color: grey888,
                      fontSize: 14,
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      height: 30,
                      child: GetBuilder<CabSearchController>(
                        init: CabSearchController(),
                        builder: (controller) => ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: Lists.cabSearchList1.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                controller.onIndexChange(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: white,
                                  border: Border.all(
                                      color: controller.selectedIndex == index
                                          ? redCA0
                                          : white),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey515.withOpacity(0.25),
                                      blurRadius: 6,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 6),
                                  child: CommonTextWidget.PoppinsMedium(
                                    text: Lists.cabSearchList1[index],
                                    color: controller.selectedIndex == index
                                        ? redCA0
                                        : black2E2,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              itemCount: Lists.outStationOneWayTabList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () {
                    Get.to(() => OutStationCabFromToScreen());
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: grey9B9.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: greyE2E, width: 1),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(trainAndBusFromToIcon),
                          SizedBox(width: 10),
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.outStationOneWayTabList[index],
                            color: grey888,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => SelectCheckInDateScreen());
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: grey9B9.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: greyE2E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(calendarPlus),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "Pick Up Time",
                            color: grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "11 Oct, 10:00 AM",
                            color: black2E2,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.to(() => SelectCheckInDateScreen());
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: grey9B9.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: greyE2E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(calendarPlus),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "Pick Up Time",
                            color: grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "12 Oct, 10:00 AM",
                            color: black2E2,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: "SEARCH",
              buttonColor: redCA0,
              onTap: () {
                // Get.to(() => CabTerminalScreen1());
              },
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
