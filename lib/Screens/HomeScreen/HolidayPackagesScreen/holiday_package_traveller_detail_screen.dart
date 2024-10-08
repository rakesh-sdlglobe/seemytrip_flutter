import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HolidayPackagesScreen/select_room_and_gust_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class HolidayPackageTravellerDetailScreen extends StatelessWidget {
  HolidayPackageTravellerDetailScreen({Key? key}) : super(key: key);

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
          text: "Traveller Details",
          color: white,
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
                      text: "FROM",
                      color: grey888,
                      fontSize: 12,
                    ),
                    SizedBox(width: 20),
                    CommonTextWidget.PoppinsMedium(
                      text: "New Delhi",
                      color: black2E2,
                      fontSize: 16,
                    ),
                  ],
                ),
                CommonTextWidget.PoppinsMedium(
                  text: "CHANGE",
                  color: redCA0,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(color: greyE8E, thickness: 5),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            title: CommonTextWidget.PoppinsMedium(
              text: "STARTING ON",
              color: grey888,
              fontSize: 12,
            ),
            subtitle: Row(
              children: [
                CommonTextWidget.PoppinsMedium(
                  text: "25 Nov 2022",
                  color: black2E2,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: "Monday",
                  color: grey888,
                  fontSize: 16,
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => SelectRoomAndGustScreen());
              },
              child: CommonTextWidget.PoppinsMedium(
                text: "CHANGE",
                color: redCA0,
                fontSize: 12,
              ),
            ),
          ),
          Divider(color: greyE8E, thickness: 5),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            title: CommonTextWidget.PoppinsMedium(
              text: "ROOMS & GUESTS",
              color: grey888,
              fontSize: 12,
            ),
            subtitle: Row(
              children: [
                CommonTextWidget.PoppinsMedium(
                  text: "2 Adults",
                  color: black2E2,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: "in",
                  color: grey888,
                  fontSize: 16,
                ),
                SizedBox(width: 10),
                CommonTextWidget.PoppinsMedium(
                  text: "1 Room",
                  color: black2E2,
                  fontSize: 16,
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => SelectRoomAndGustScreen());
              },
              child: CommonTextWidget.PoppinsMedium(
                text: "CHANGE",
                color: redCA0,
                fontSize: 12,
              ),
            ),
          ),
          Divider(color: greyE8E, thickness: 5),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              onTap: () {},
              buttonColor: redCA0,
              text: "APPLY",
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
