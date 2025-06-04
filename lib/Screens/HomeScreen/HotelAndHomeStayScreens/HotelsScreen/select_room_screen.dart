import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_review_booking_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class SelectRoomScreen extends StatelessWidget {
  SelectRoomScreen({Key? key}) : super(key: key);

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
          text: "Select Room",
          color: white,
          fontSize: 18,
        ),
        actions: [
          InkWell(
            onTap: () {
              // Get.back();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 24, top: 20),
              child: CommonTextWidget.PoppinsMedium(
                text: "Modify",
                color: white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                color: redF9E.withOpacity(0.75),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: Image.asset(selectRoomImage1),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Image.asset(selectRoomImage2, height: 110, width: 201),
                    SizedBox(height: 15),
                    Image.asset(selectRoomImage3,
                        height: 178, width: Get.width),
                    Image.asset(selectRoomImage4,
                        height: 237, width: Get.width),
                    Image.asset(selectRoomImage5,
                        height: 199, width: Get.width),
                  ],
                ),
              ),
              Image.asset(selectRoomImage6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Image.asset(selectRoomImage7, height: 110, width: 201),
                    SizedBox(height: 15),
                    Image.asset(selectRoomImage8,
                        height: 178, width: Get.width),
                    Image.asset(selectRoomImage9,
                        height: 237, width: Get.width),
                    Image.asset(selectRoomImage10,
                        height: 199, width: Get.width),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: Get.width,
                color: black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "₹ 7,950",
                            color: white,
                            fontSize: 16,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: "+ ₹870 taxes & service fees",
                            color: white,
                            fontSize: 10,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: "Per Night (2 Adults)",
                            color: white,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.to(() => HotelReviewBookingScreen());
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
