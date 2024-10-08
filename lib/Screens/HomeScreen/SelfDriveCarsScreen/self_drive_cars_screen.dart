import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/AirportCabsScreens/select_travell_date_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/SelfDriveCarsScreen/search_pickup_area_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/SelfDriveCarsScreen/self_drive_cars_select_dates_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class SelfDriveCarsScreen extends StatelessWidget {
   SelfDriveCarsScreen({Key? key}) : super(key: key);

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
          text: "Self Drive Cars",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.to(() => SearchPickUpAreaScreen());
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: grey9B9.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: greyE2E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(trainAndBusFromToIcon),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text:"Pickup & Drop-Off Loaction",
                            color: grey888,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Area,Airport or City",
                            color: black2E2,
                            fontSize: 14,
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
                Get.to(() => SelfDriveCarsSelectTravelDateScreen());
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
                            text: "Start Date/Time",
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
                Get.to(() => SelfDriveCarsSelectTravelDateScreen());
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
                            text: "Drop-Off Time",
                            color: grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "End Date/Time",
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
