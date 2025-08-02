import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                                Icon(Icons.arrow_back, color: white, size: 20),
                          ),
                          Row(
                            children: [
                              Icon(Icons.share, color: white),
                              SizedBox(width: 35),
                              Icon(Icons.favorite_border, color: white),
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
                      text: "Spectacular Krabi and Phuket Getaway",
                      color: black,
                      fontSize: 15,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: "2N Krabi   3N Phuket",
                      color: grey717,
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
                            color: green00A,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "5N/6D",
                              color: white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 20,
                          width: 92,
                          decoration: BoxDecoration(
                            color: black2E2,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: "Flexi Package",
                              color: white,
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
                        color: redF9E.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: greyE7E, width: 1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget.PoppinsRegular(
                              text: "New Delhi",
                              color: grey717,
                              fontSize: 12,
                            ),
                            Icon(Icons.circle, color: redCA0, size: 6),
                            CommonTextWidget.PoppinsRegular(
                              text: "Travellers",
                              color: grey717,
                              fontSize: 12,
                            ),
                            Icon(Icons.circle, color: redCA0, size: 6),
                            CommonTextWidget.PoppinsRegular(
                              text: "28 Nov - 3 Dec",
                              color: grey717,
                              fontSize: 12,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    HolidayPackageTravellerDetailScreen());
                              },
                              child: CommonTextWidget.PoppinsMedium(
                                text: "Edit",
                                color: redCA0,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: greyE8E, thickness: 5),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsSemiBold(
                      text: "ltinerary",
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: "Day Wise Details of your Package",
                      color: grey717,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: greyE8E, thickness: 5),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: "Importatnt information",
                      color: black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: redF9E.withOpacity(0.95),
                        border: Border.all(
                          color: redCA0.withOpacity(0.4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        leading: Image.asset(thailand),
                        title: CommonTextWidget.PoppinsMedium(
                          text: "Thai Pass is not needed for Thailand travel",
                          color: black2E2,
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
                                color: redCA0,
                                fontSize: 12,
                              ),
                              SvgPicture.asset(arrowDownIcon, color: redCA0),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(color: greyE8E, thickness: 1),
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
                    color: black2E2,
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
                                "₹ 60,158",
                                style: TextStyle(
                                  color: greyD7D,
                                  fontSize: 10,
                                  fontFamily: FontFamily.PoppinsMedium,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: "₹ 47,533",
                                color: white,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "Per Person",
                                color: greyD7D,
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
                            color: redCA0,
                            child: CommonTextWidget.PoppinsSemiBold(
                              fontSize: 16,
                              text: "Book Now",
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
        ],
      ),
    );
  }
}
