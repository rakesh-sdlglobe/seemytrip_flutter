import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import 'select_visa_type_screen.dart';

class GetVisaOnlineScreen extends StatelessWidget {
  GetVisaOnlineScreen({Key? key}) : super(key: key);

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
            text: 'Get Visa Online',
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'DESTINATION',
                color: AppColors.grey717,
                fontSize: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'United Arab Emirates',
                color: AppColors.black2E2,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Divider(color: AppColors.greyE8E, thickness: 1),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(getVisaOnlineImage1, height: 74, width: 104),
                  Image.asset(getVisaOnlineImage2, height: 74, width: 104),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(color: AppColors.greyE8E, thickness: 1),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'TRAVELLERS',
                color: AppColors.grey717,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 37,
                width: 98,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.greyB3B, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.remove, color: AppColors.grey717, size: 10),
                      CommonTextWidget.PoppinsMedium(
                        text: '01',
                        color: AppColors.black2E2,
                        fontSize: 18,
                      ),
                      Icon(Icons.add, color: AppColors.grey717, size: 10),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonButtonWidget.button(
                text: 'APPLY',
                onTap: () {
                  Get.to(() => SelectVisaTypeScreen());
                },
                buttonColor: AppColors.redCA0,
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      );
}
