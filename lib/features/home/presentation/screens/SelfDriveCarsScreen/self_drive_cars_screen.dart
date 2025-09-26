import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import 'search_pickup_area_screen.dart';
import 'self_drive_cars_select_dates_screen.dart';

class SelfDriveCarsScreen extends StatelessWidget {
   SelfDriveCarsScreen({Key? key}) : super(key: key);

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
          text: 'Self Drive Cars',
          color: AppColors.white,
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
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE2E, width: 1),
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
                            text: 'Pickup & Drop-Off Loaction',
                            color: AppColors.grey888,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Area,Airport or City',
                            color: AppColors.black2E2,
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
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE2E, width: 1),
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
                            text: 'Pick Up Time',
                            color: AppColors.grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Start Date/Time',
                            color: AppColors.black2E2,
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
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE2E, width: 1),
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
                            text: 'Drop-Off Time',
                            color: AppColors.grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'End Date/Time',
                            color: AppColors.black2E2,
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
              text: 'SEARCH',
              buttonColor: AppColors.redCA0,
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
