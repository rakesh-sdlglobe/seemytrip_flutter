import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/Screens/Where2GoScreen/booking_option_screen.dart';
import 'package:seemytrip/main.dart';

class InterNationalDetailScreen2 extends StatelessWidget {
  InterNationalDetailScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(internationalDetail2Image1),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(internationalDetailBackImage),
                      ),
                      SvgPicture.asset(internationalDetail2ShareImage),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Image.asset(
                  internationalDetail2Image2,
                  height: 267,
                  width: 327,
                ),
              ),
              SizedBox(
                height: 215,
                child: ListView.builder(
                  itemCount: Lists.internationalDetail2List1.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Image.asset(
                    Lists.internationalDetail2List1[index],
                    height: 215,
                    width: 230,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Image.asset(
                  internationalDetail2Image5,
                  height: 215,
                  width: 207,
                ),
              ),
              SizedBox(height: 15),
              Divider(color: greyE8E, thickness: 1),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "People Also Bought These",
                  color: black2E2,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 204,
                child: ListView.builder(
                  itemCount: Lists.applyTouristList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 18, right: 24, top: 0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Image.asset(
                      Lists.applyTouristList[index],
                      height: 204,
                      width: 156),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 60,
                width: Get.width,
                color: black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "₹ 3,145",
                            color: white,
                            fontSize: 16,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: "Per Person",
                            color: white,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      MaterialButton(
                        onPressed: () {
                          Get.to(() => BookingOptionScreen());
                        },
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: "VIEW DEALS",
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
