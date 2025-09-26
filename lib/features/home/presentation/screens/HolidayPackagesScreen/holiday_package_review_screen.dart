import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class HolidayPackageReviewScreen extends StatelessWidget {
  HolidayPackageReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.redF9E,
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
          text: 'Review Page',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(holidayPackageReviewImage1),
                  ),
                  SizedBox(height: 15),
                  ListView.builder(
                    itemCount: Lists.holidayPackageReviewList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withValues(alpha: 0.25),
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CommonTextWidget.PoppinsMedium(
                            text: Lists.holidayPackageReviewList[index]
                                ['text1'],
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                          title: CommonTextWidget.PoppinsMedium(
                            text: Lists.holidayPackageReviewList[index]
                                ['text2'],
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                          trailing: Icon(Icons.edit, color: AppColors.redCA0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(holidayPackageReviewImage2),
                  ),
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width,
                    color: AppColors.black2E2,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reserve for ₹ 11,000*',
                                style: TextStyle(
                                  color: AppColors.greyD7D,
                                  fontSize: 10,
                                  fontFamily: FontFamily.PoppinsMedium,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: '₹ 1,05,046',
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: 'Grand Total - 2 Travellers',
                                color: AppColors.greyD7D,
                                fontSize: 8,
                              ),
                            ],
                          ),
                          MaterialButton(
                            onPressed: () {},
                            height: 40,
                            minWidth: 140,
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: AppColors.redCA0,
                            child: CommonTextWidget.PoppinsSemiBold(
                              fontSize: 16,
                              text: 'Continue',
                              color: AppColors.white,
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
        ],
      ),
    );
}
