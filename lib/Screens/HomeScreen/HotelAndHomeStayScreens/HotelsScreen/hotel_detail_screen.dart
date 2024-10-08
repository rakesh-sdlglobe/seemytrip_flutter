import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_search_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/rate_plan_detail_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/select_room_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class HotelDetailScreen extends StatelessWidget {
  HotelDetailScreen({Key? key}) : super(key: key);

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
                height: 250,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(hotelDetailTopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 55),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child:
                                SvgPicture.asset(internationalDetailBackImage),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => HotelDetailSearchScreen());
                                },
                                child: SvgPicture.asset(
                                    internationalDetailSearchImage),
                              ),
                              SizedBox(width: 20),
                              SvgPicture.asset(hotelDetailHeartIcon),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(hotelDetailTopImage2,
                              height: 26, width: 103),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(hotelDetailImage3, height: 163, width: 327),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(hotelDetailImage4, height: 23, width: 134),
                    InkWell(
                      onTap: () {
                        Get.to(() => SelectCheckInDateScreen());
                      },
                      child: Row(
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "View Calendar",
                            color: redCA0,
                            fontSize: 11,
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: redCA0, size: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.hotelDetailList1.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: Lists.hotelDetailList1[index]["onTap"],
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: grey9B9.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: greyE2E),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Lists.hotelDetailList1[index]["image"]),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.hotelDetailList1[index]["text1"],
                                  color: grey888,
                                  fontSize: 14,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.hotelDetailList1[index]["text2"],
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
                ),
              ),
              SizedBox(height: 15),
              Divider(color: greyE8E, thickness: 1),
              SizedBox(height: 15),
              Image.asset(hotelDetailImage5),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(hotelDetailImage6, height: 25, width: 240),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 24, right: 9),
                  shrinkWrap: true,
                  itemCount: Lists.hotelDetailList2.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Image.asset(Lists.hotelDetailList2[index],
                        height: 150, width: 150),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Get.width,
                        color: black2E2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
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
                                  Get.to(() => RatePlanDetailScreen());
                                },
                                height: 40,
                                minWidth: 140,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: redCA0,
                                child: CommonTextWidget.PoppinsSemiBold(
                                  fontSize: 16,
                                  text: "SELECT ROOM",
                                  color: white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
