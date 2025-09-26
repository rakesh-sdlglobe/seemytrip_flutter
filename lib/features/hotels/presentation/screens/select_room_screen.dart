import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../main.dart';
import '../../../../shared/constants/images.dart';
import 'hotel_review_booking_screen.dart';

class SelectRoomScreen extends StatelessWidget {
  SelectRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Select Room',
          color: AppColors.white,
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
                text: 'Modify',
                color: AppColors.white,
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
                color: AppColors.redF9E.withValues(alpha: 0.75),
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
                color: AppColors.black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: '₹ 7,950',
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: '+ ₹870 taxes & service fees',
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: 'Per Night (2 Adults)',
                            color: AppColors.white,
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
                        color: AppColors.redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: 'CONTINUE',
                          color: AppColors.white,
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
