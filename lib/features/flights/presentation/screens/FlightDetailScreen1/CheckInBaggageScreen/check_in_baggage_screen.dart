import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/common_text_widget.dart';
import '../../../../../../core/widgets/lists_widget.dart';
import '../../../../../../shared/constants/images.dart';
import '../FareBreakUpScreen1/fare_break_up_screen1.dart';

class CheckInBaggageScreen extends StatelessWidget {
  CheckInBaggageScreen({Key? key}) : super(key: key);

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
          child: Icon(Icons.close, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Check-in Baggage',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Container(
              height: 500,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Image.asset(spicejet, height: 30, width: 30),
                          SizedBox(width: 10),
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'DEL - BOM',
                            color: AppColors.black2E2,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CommonTextWidget.PoppinsRegular(
                        text: 'Included Check-in baggage per person - 15 KGS',
                        color: AppColors.black2E2,
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Lists.checkInBaggageList.length,
                      padding: EdgeInsets.only(top: 0),
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: SvgPicture.asset(weightScale),
                            title: CommonTextWidget.PoppinsMedium(
                              text: Lists.checkInBaggageList[index]['text1'],
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                            subtitle: CommonTextWidget.PoppinsMedium(
                              text: Lists.checkInBaggageList[index]['text2'],
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                            trailing: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.greyD9D, width: 1),
                              ),
                              child: Center(
                                child: CommonTextWidget.PoppinsMedium(
                                  text: 'ADD',
                                  color: AppColors.black2E2,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            horizontalTitleGap: -3,
                          ),
                          index == 4
                              ? SizedBox.shrink()
                              : Divider(color: AppColors.greyE8E, thickness: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: Get.width,
                color: AppColors.black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: '₹ 5,950',
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: 'FOR 1 ADULT',
                                color: AppColors.white,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Get.to(() => FareBreakUpScreen1());
                            },
                            child: SvgPicture.asset(info),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {},
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: AppColors.redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: 'CONTINUE',
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
