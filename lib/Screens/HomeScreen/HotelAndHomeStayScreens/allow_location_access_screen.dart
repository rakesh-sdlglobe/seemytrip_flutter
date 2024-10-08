import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/hotel_and_home_stay_tab_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class AllowLocationAccessScreen extends StatelessWidget {
  AllowLocationAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 430),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Allow Location Access",
              color: black2E2,
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
            CommonTextWidget.PoppinsRegular(
              text: "To enchance your in-app experience!",
              color: grey717,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            SvgPicture.asset(placeholder),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: CommonTextWidget.PoppinsRegular(
                text:
                    "With this, we will be able to offer you Personalised experience",
                color: grey717,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonTextWidget.PoppinsMedium(
                      text: "EDIT",
                      color: redCA0,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => HotelAndHomeStayTabScreen());
                    },
                    child: CommonTextWidget.PoppinsMedium(
                      text: "CONFIRM",
                      color: redCA0,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
