import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/VisaServicesScreen/select_visa_type_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class GetVisaOnlineScreen extends StatelessWidget {
  GetVisaOnlineScreen({Key? key}) : super(key: key);

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
          text: "Get Visa Online",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "DESTINATION",
              color: grey717,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "United Arab Emirates",
              color: black2E2,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          Divider(color: greyE8E, thickness: 1),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(getVisaOnlineImage1, height: 74, width: 104),
                Image.asset(getVisaOnlineImage2, height: 74, width: 104),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(color: greyE8E, thickness: 1),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "TRAVELLERS",
              color: grey717,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 37,
              width: 98,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: greyB3B, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.remove, color: grey717, size: 10),
                    CommonTextWidget.PoppinsMedium(
                      text: "01",
                      color: black2E2,
                      fontSize: 18,
                    ),
                    Icon(Icons.add, color: grey717, size: 10),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              text: "APPLY",
              onTap: () {
                Get.to(() => SelectVisaTypeScreen());
              },
              buttonColor: redCA0,
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
