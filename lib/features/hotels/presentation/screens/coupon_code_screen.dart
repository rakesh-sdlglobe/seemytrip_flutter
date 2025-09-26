import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../core/utils/common_textfeild_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';

class CouponCodeScreen extends StatelessWidget {
  CouponCodeScreen({Key? key}) : super(key: key);
  final TextEditingController codeController = TextEditingController();

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
          child: Icon(Icons.cancel, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Coupon Codes',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CommonTextWidget.PoppinsSemiBold(
              text: 'Have a coupon code?',
              color: AppColors.black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 15),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey515.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text: 'COUPON OR DEAL CODE',
                      color: AppColors.grey717,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget(
                      keyboardType: TextInputType.text,
                      controller: codeController,
                      hintText: 'Enter the coupon or deal code',
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: 'APPLY',
              onTap: () {},
              buttonColor: AppColors.redCA0,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

