import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

import 'holiday_package_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  String title;

  ExploreScreen(this.title);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
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
                    child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: 'Explore',
                    color: AppColors.white,
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
                            ? AppColors.redF8E
                            : AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 6,
                            color: AppColors.grey515.withValues(alpha: 0.25),
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
                                ? AppColors.redCA0
                                : AppColors.grey969,
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
          Divider(color: AppColors.greyE8E, thickness: 1),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsSemiBold(
              text: 'Best selling destinations',
              color: AppColors.black2E2,
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
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Divider(color: AppColors.greyE8E, thickness: 1),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsSemiBold(
              text: 'Emerging',
              color: AppColors.black2E2,
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
                      color: AppColors.black2E2,
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
