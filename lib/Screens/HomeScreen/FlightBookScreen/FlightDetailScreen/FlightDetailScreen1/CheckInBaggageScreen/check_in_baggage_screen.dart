import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

import '../FareBreakUpScreen1/fare_break_up_screen1.dart';

class CheckInBaggageScreen extends StatelessWidget {
  CheckInBaggageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Check-in Baggage",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Container(
              height: 500,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Image.asset(spicejet, height: 30, width: 30),
                          SizedBox(width: 10),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "DEL - BOM",
                            color: black2E2,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CommonTextWidget.PoppinsRegular(
                        text: "Included Check-in baggage per person - 15 KGS",
                        color: black2E2,
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Lists.checkInBaggageList.length,
                      padding: EdgeInsets.only(top: 0),
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: SvgPicture.asset(weightScale),
                            title: CommonTextWidget.PoppinsMedium(
                              text: Lists.checkInBaggageList[index]["text1"],
                              color: black2E2,
                              fontSize: 12,
                            ),
                            subtitle: CommonTextWidget.PoppinsMedium(
                              text: Lists.checkInBaggageList[index]["text2"],
                              color: black2E2,
                              fontSize: 12,
                            ),
                            trailing: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: greyD9D, width: 1),
                              ),
                              child: Center(
                                child: CommonTextWidget.PoppinsMedium(
                                  text: "ADD",
                                  color: black2E2,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            horizontalTitleGap: -3,
                          ),
                          index == 4
                              ? SizedBox.shrink()
                              : Divider(color: greyE8E, thickness: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: Get.width,
                color: black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Get.to(() => FareBreakUpScreen1());
                            },
                            child: SvgPicture.asset(info),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {},
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
          ),
        ],
      ),
    );
  }
}
