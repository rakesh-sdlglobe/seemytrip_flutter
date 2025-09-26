import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/home/presentation/screens/HolidayPackagesScreen/holiday_package_review_screen.dart';
import 'package:seemytrip/features/home/presentation/screens/HolidayPackagesScreen/holiday_package_traveller_detail_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class PackageDetailScreen extends StatelessWidget {
  PackageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(packageDetailImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 65, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child:
                                Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                          ),
                          Row(
                            children: [
                              Icon(Icons.share, color: AppColors.white),
                              SizedBox(width: 35),
                              Icon(Icons.favorite_border, color: AppColors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: 'Spectacular Krabi and Phuket Getaway',
                      color: AppColors.black,
                      fontSize: 15,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: '2N Krabi   3N Phuket',
                      color: AppColors.grey717,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.green00A,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: '5N/6D',
                              color: AppColors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 20,
                          width: 92,
                          decoration: BoxDecoration(
                            color: AppColors.black2E2,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: 'Flexi Package',
                              color: AppColors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.redF9E.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.greyE7E, width: 1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget.PoppinsRegular(
                              text: 'New Delhi',
                              color: AppColors.grey717,
                              fontSize: 12,
                            ),
                            Icon(Icons.circle, color: AppColors.redCA0, size: 6),
                            CommonTextWidget.PoppinsRegular(
                              text: 'Travellers',
                              color: AppColors.grey717,
                              fontSize: 12,
                            ),
                            Icon(Icons.circle, color: AppColors.redCA0, size: 6),
                            CommonTextWidget.PoppinsRegular(
                              text: '28 Nov - 3 Dec',
                              color: AppColors.grey717,
                              fontSize: 12,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    HolidayPackageTravellerDetailScreen());
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
                  SizedBox(height: 20),
                  Divider(color: AppColors.greyE8E, thickness: 5),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: 'ltinerary',
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: 'Day Wise Details of your Package',
                      color: AppColors.grey717,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: AppColors.greyE8E, thickness: 5),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: 'Importatnt information',
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.redF9E.withOpacity(0.95),
                        border: Border.all(
                          color: AppColors.redCA0.withOpacity(0.4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        leading: Image.asset(thailand),
                        title: CommonTextWidget.PoppinsMedium(
                          text: 'Thai Pass is not needed for Thailand travel',
                          color: AppColors.black2E2,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: Lists.packageDetailList.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: Lists.packageDetailList[index],
                                color: AppColors.redCA0,
                                fontSize: 12,
                              ),
                              SvgPicture.asset(arrowDownIcon, color: AppColors.redCA0),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(color: AppColors.greyE8E, thickness: 1),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
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
                                '₹ 60,158',
                                style: TextStyle(
                                  color: AppColors.greyD7D,
                                  fontSize: 10,
                                  fontFamily: FontFamily.PoppinsMedium,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: '₹ 47,533',
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: 'Per Person',
                                color: AppColors.greyD7D,
                                fontSize: 8,
                              ),
                            ],
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.to(()=>HolidayPackageReviewScreen());
                            },
                            height: 40,
                            minWidth: 140,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: AppColors.redCA0,
                            child: CommonTextWidget.PoppinsSemiBold(
                              fontSize: 16,
                              text: 'Book Now',
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
