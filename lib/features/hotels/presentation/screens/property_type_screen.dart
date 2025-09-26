import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/common_container_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../main.dart';
import '../../../../shared/constants/images.dart';

class PropertyTypeScreen extends StatelessWidget {
  PropertyTypeScreen({Key? key}) : super(key: key);

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
            child: Icon(Icons.close, color: AppColors.white, size: 20),
          ),
          title: CommonTextWidget.PoppinsSemiBold(
            text: 'Property Type',
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: 'Star Rating',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: '5 star',
                              color: AppColors.black2E2,
                              fontSize: 13,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(48)',
                              color: AppColors.grey717,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 13),
                      Container(
                        height: 60,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: '4 star',
                              color: AppColors.black2E2,
                              fontSize: 13,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(248)',
                              color: AppColors.grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 13),
                      Container(
                        height: 60,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: '3 star',
                              color: AppColors.black2E2,
                              fontSize: 13,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(402)',
                              color: AppColors.grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: AppColors.greyE8E, thickness: 1),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: 'Property Type',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 111,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              review,
                              height: 40,
                              width: 40,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(height: 11.25),
                            CommonTextWidget.PoppinsMedium(
                              text: 'Hotel',
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(458)',
                              color: AppColors.grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 13),
                      Container(
                        height: 111,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              villa,
                              height: 40,
                              width: 40,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(height: 11.25),
                            CommonTextWidget.PoppinsMedium(
                              text: 'Villas',
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(225)',
                              color: AppColors.grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 13),
                      Container(
                        height: 111,
                        width: 87,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey515.withOpacity(0.25),
                              blurRadius: 16,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              resort,
                              height: 40,
                              width: 40,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(height: 11.25),
                            CommonTextWidget.PoppinsMedium(
                              text: 'Resort',
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: '(596)',
                              color: AppColors.grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CommonContainerWidget.container(
                        // width: 130.0,
                        text: 'Homestay (758)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 146.0,
                        text: 'Guest House (758)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CommonContainerWidget.container(
                        // width: 90.0,
                        text: 'Hostel (25)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 130.0,
                        text: 'Apart-hotel (85)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 70.0,
                        text: 'BnB (14)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CommonContainerWidget.container(
                        // width: 144.0,
                        text: 'Holiday Home (19)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 116.0,
                        text: 'Beach hut (12)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CommonContainerWidget.container(
                        // width: 125.0,
                        text: 'Farm House (5)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 118.0,
                        text: 'Tree House (2)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CommonContainerWidget.container(
                        // width: 86.0,
                        text: 'Camp (4)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                      SizedBox(width: 10),
                      CommonContainerWidget.container(
                        // width: 80.0,
                        text: 'Lodge (1)',
                        borderColor: AppColors.white,
                        textColor: AppColors.grey717,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonButtonWidget.button(
                    text: 'DONE',
                    onTap: () {},
                    buttonColor: AppColors.redCA0,
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      );
}
