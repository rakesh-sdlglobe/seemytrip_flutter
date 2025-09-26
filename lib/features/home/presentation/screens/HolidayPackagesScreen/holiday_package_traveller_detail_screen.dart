import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/features/home/presentation/screens/HolidayPackagesScreen/select_room_and_gust_screen.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class HolidayPackageTravellerDetailScreen extends StatelessWidget {
  HolidayPackageTravellerDetailScreen({Key? key}) : super(key: key);

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
          text: 'Traveller Details',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 22),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CommonTextWidget.PoppinsMedium(
                      text: 'FROM',
                      color: AppColors.grey888,
                      fontSize: 12,
                    ),
                    SizedBox(width: 20),
                    CommonTextWidget.PoppinsMedium(
                      text: 'New Delhi',
                      color: AppColors.black2E2,
                      fontSize: 16,
                    ),
                  ],
                ),
                CommonTextWidget.PoppinsMedium(
                  text: "CHANGE",
                  color: AppColors.redCA0,
                  fontSize: 12,
                ),
              ],  
            ),
          ),
          SizedBox(height: 20),
          Divider(color: AppColors.greyE8E, thickness: 5),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            title: CommonTextWidget.PoppinsMedium(
              text: 'STARTING ON',
              color: AppColors.grey888,
              fontSize: 12,
            ),
            subtitle: Row(
              children: [
                CommonTextWidget.PoppinsMedium(
                  text: '25 Nov 2022',
                  color: AppColors.black2E2,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: 'Monday',
                  color: AppColors.grey888,
                  fontSize: 16,
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => SelectRoomAndGustScreen());
              },
              child: CommonTextWidget.PoppinsMedium(
                text: 'CHANGE',
                color: AppColors.redCA0,
                fontSize: 12,
              ),
            ),
          ),
          Divider(color: AppColors.greyE8E, thickness: 5),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            title: CommonTextWidget.PoppinsMedium(
              text: 'ROOMS & GUESTS',
              color: AppColors.grey888,
              fontSize: 12,
            ),
            subtitle: Row(
              children: [
                CommonTextWidget.PoppinsMedium(
                  text: '2 Adults',
                  color: AppColors.black2E2,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: 'in',
                  color: AppColors.grey888,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: '1 Room',
                  color: AppColors.black2E2,
                  fontSize: 16,
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => SelectRoomAndGustScreen());
              },
              child: CommonTextWidget.PoppinsMedium(
                text: 'CHANGE',
                color: AppColors.redCA0,
                fontSize: 12,
              ),
            ),
          ),
          Divider(color: AppColors.greyE8E, thickness: 5),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              onTap: () {},
              buttonColor: AppColors.redCA0,
              text: 'APPLY',
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
}
