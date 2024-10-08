import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

import 'holiday_package_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  String title;

  ExploreScreen(this.title);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(exploreImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Explore",
                    color: white,
                    fontSize: 18,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 70,
            width: Get.width,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                itemCount: Lists.holidayPackagesList1.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.title = Lists.holidayPackagesList1[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.title == Lists.holidayPackagesList1[index]
                            ? redF8E
                            : white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 6,
                            color: grey515.withOpacity(0.25),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CommonTextWidget.PoppinsMedium(
                            text: Lists.holidayPackagesList1[index],
                            color: widget.title ==
                                    Lists.holidayPackagesList1[index]
                                ? redCA0
                                : grey969,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Divider(color: greyE8E, thickness: 1),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsSemiBold(
              text: "Best selling destinations",
              color: black2E2,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 24, right: 9),
              itemCount: Lists.holidayPackagesList2.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () {
                    Get.to(() => HolidayPackageDetailScreen());
                  },
                  child: Column(
                    children: [
                      Image.asset(Lists.holidayPackagesList2[index]["image"],
                          height: 80, width: 80),
                      SizedBox(height: 10),
                      CommonTextWidget.PoppinsMedium(
                        text: Lists.holidayPackagesList2[index]["text"],
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Divider(color: greyE8E, thickness: 1),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsSemiBold(
              text: "Emerging",
              color: black2E2,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 24, right: 9),
              itemCount: Lists.exploreList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 15),
                child: Column(
                  children: [
                    Image.asset(Lists.exploreList[index]["image"],
                        height: 80, width: 80),
                    SizedBox(height: 10),
                    CommonTextWidget.PoppinsMedium(
                      text: Lists.exploreList[index]["text"],
                      color: black2E2,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
