import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';
import '../../../../shared/constants/images.dart';
import '../../../cabs/presentation/controllers/cab_search_controller.dart';
import 'airport_cabs_screen.dart';
import 'cab_terminal_screen1.dart';
import 'select_travell_date_screen.dart';

class CabSearchScreen extends StatelessWidget {
  CabSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
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
          text: 'Cab Search',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.yellowF7C.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(info, color: AppColors.yellowCE8),
                        SizedBox(width: 10),
                        CommonTextWidget.PoppinsRegular(
                          text: 'Pre-book Airport Drop',
                          color: AppColors.yellowCE8,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.grey9B9.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.greyE2E, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                    child: Row(
                      children: [
                        SvgPicture.asset(arrowsLeftRight),
                        SizedBox(width: 10),
                        CommonTextWidget.PoppinsMedium(
                          text: 'Travel',
                          color: AppColors.grey888,
                          fontSize: 14,
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          height: 30,
                          child: GetBuilder<CabSearchController>(
                            init: CabSearchController(),
                            builder: (controller) => ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Lists.cabSearchList1.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    controller.onIndexChange(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.white,
                                      border: Border.all(
                                          color:
                                              controller.selectedIndex == index
                                                  ? AppColors.redCA0
                                                  : AppColors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.grey515.withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 6),
                                      child: CommonTextWidget.PoppinsMedium(
                                        text: Lists.cabSearchList1[index],
                                        color: controller.selectedIndex == index
                                            ? AppColors.redCA0
                                            : AppColors.black2E2,
                                        fontSize: 10,
                                      ),
                                    ),
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
                SizedBox(height: 15),
                ListView.builder(
                  itemCount: Lists.cabSearchList2.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AirportCabsScreen());
                      },
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.grey9B9.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColors.greyE2E, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(trainAndBusFromToIcon),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: Lists.cabSearchList2[index]["text1"],
                                    color: AppColors.grey888,
                                    fontSize: 14,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: Lists.cabSearchList2[index]
                                            ["text2"],
                                        color: AppColors.black2E2,
                                        fontSize: 14,
                                      ),
                                      CommonTextWidget.PoppinsRegular(
                                        text: Lists.cabSearchList2[index]
                                            ["text3"],
                                        color: AppColors.black2E2,
                                        fontSize: 14,
                                      ),
                                    ],
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
                InkWell(
                  onTap: () {
                    Get.to(() => SelectTravelDateScreen());
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.grey9B9.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.greyE2E, width: 1),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                      child: Row(
                        children: [
                          SvgPicture.asset(calendarPlus),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: 'Pick Up Time',
                                color: AppColors.grey888,
                                fontSize: 12,
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: '09 Oct, 10 AM',
                                color: AppColors.black2E2,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            child: GetBuilder<CabSearchController>(
                              init: CabSearchController(),
                              builder: (controller) => ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Lists.cabSearchList1.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      controller.onIndexChange1(index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: controller.selectedIndex1 ==
                                                    index
                                                ? AppColors.redCA0
                                                : AppColors.white),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.grey515.withValues(alpha: 0.25),
                                            blurRadius: 6,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 6),
                                        child: CommonTextWidget.PoppinsMedium(
                                          text: Lists.cabSearchList3[index],
                                          color:
                                              controller.selectedIndex1 == index
                                                  ? AppColors.redCA0
                                                  : AppColors.black2E2,
                                          fontSize: 10,
                                        ),
                                      ),
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
                ),
              ],
            ),
          ),
          Positioned(
            right: 32,
            top: 205,
            child: InkWell(
              onTap: () {
                // Get.to(() => SortAndFilterScreen());
              },
              child: Container(
                height: 45,
                width: 33,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.greyE2E,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(arrowsDownUp),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 60),
            child: CommonButtonWidget.button(
              text: 'SEARCH',
              buttonColor: AppColors.redCA0,
              onTap: () {
                Get.to(() => CabTerminalScreen1());
              },
            ),
          ),
        ],
      ),
    );
}
