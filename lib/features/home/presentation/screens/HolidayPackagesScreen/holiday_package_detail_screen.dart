import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/home/presentation/screens/HolidayPackagesScreen/edit_your_search_screen.dart';
import 'package:seemytrip/features/home/presentation/screens/HolidayPackagesScreen/package_screen.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class HolidayPackageDetailScreen extends StatelessWidget {
  HolidayPackageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  width: Get.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(holidayPackageDetailImage),
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
                          child: Icon(Icons.arrow_back,
                              color: AppColors.white, size: 20),
                        ),
                        CommonTextWidget.PoppinsSemiBold(
                          text: 'Thailand',
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
                      itemCount: Lists.holidayPackagesDetailList1.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                          top: 13, bottom: 13, left: 24, right: 12),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: Lists.holidayPackagesDetailList1[index]
                              ["onTap"],
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.white,
                                border: Border.all(
                                    color: AppColors.greyB3B, width: 1)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: CommonTextWidget.PoppinsMedium(
                                  text: Lists.holidayPackagesDetailList1[index]
                                      ["text"],
                                  color: AppColors.grey5F5,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.grey9B9.withValues(alpha: 0.15),
                      border: Border.all(color: AppColors.greyE2E, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: 'New Delhi',
                                color: AppColors.grey717,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: '- Thailand',
                                color: AppColors.black2E2,
                                fontSize: 14,
                              ),
                            ],
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: 'Add Travel date',
                            color: AppColors.grey717,
                            fontSize: 12,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => EditYourSearchScreen());
                            },
                            child: CommonTextWidget.PoppinsMedium(
                              text: 'Edit',
                              color: AppColors.redCA0,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: 'Deal-Wothy Thailand Holidays!',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 255,
                  width: Get.width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      itemCount: Lists.holidayPackagesDetailList2.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                          top: 13, bottom: 13, left: 24, right: 12),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => PackageDetailScreen());
                          },
                          child: Image.asset(
                            Lists.holidayPackagesDetailList2[index],
                            height: 255,
                            width: 215,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: 'A Treat gor the Honeymoons!',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 255,
                  width: Get.width,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      itemCount: Lists.holidayPackagesDetailList3.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                          top: 13, bottom: 13, left: 24, right: 12),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            // Get.to(() => ExploreScreen());
                          },
                          child: Image.asset(
                            Lists.holidayPackagesDetailList3[index],
                            height: 255,
                            width: 215,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
