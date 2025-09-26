import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../cabs/presentation/controllers/cab_search_controller.dart';
import '../../../../hotels/presentation/screens/select_checkin_date_screen.dart';
import 'out_station_cab_from_to_screen.dart';

class OutStationCabScreen extends StatelessWidget {
  OutStationCabScreen({Key? key}) : super(key: key);

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
          text: 'Outstation Cabs',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
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
                  children: <Widget>[
                    SvgPicture.asset(info, color: AppColors.yellowCE8),
                    SizedBox(width: 10),
                    CommonTextWidget.PoppinsRegular(
                      text: 'Includes one pick up & drop',
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
                  children: <Widget>[
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
                        builder: (CabSearchController controller) => ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: Lists.cabSearchList1.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) => Padding(
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
                                      color: controller.selectedIndex == index
                                          ? AppColors.redCA0
                                          : AppColors.white),
                                  boxShadow: <BoxShadow>[
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
              itemCount: Lists.outStationOneWayTabList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () {
                    Get.to(() => OutStationCabFromToScreen());
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
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(trainAndBusFromToIcon),
                          SizedBox(width: 10),
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.outStationOneWayTabList[index],
                            color: AppColors.grey888,
                            fontSize: 14,
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
                Get.to(() => SelectCheckInDateScreen());
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE2E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(calendarPlus),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CommonTextWidget.PoppinsMedium(
                            text: 'Pick Up Time',
                            color: AppColors.grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: '11 Oct, 10:00 AM',
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.to(() => SelectCheckInDateScreen());
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE2E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(calendarPlus),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CommonTextWidget.PoppinsMedium(
                            text: 'Pick Up Time',
                            color: AppColors.grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: '12 Oct, 10:00 AM',
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: 'SEARCH',
              buttonColor: AppColors.redCA0,
              onTap: () {
                // Get.to(() => CabTerminalScreen1());
              },
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
}
