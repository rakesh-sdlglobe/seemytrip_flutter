import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/common_container_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';

class PriceRangeScreen extends StatelessWidget {
  PriceRangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
          text: 'Price Range',
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
              text: 'Price Per Night',
              color: AppColors.black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: '₹0 - ₹2000(851)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: '₹2000 - ₹4000(856)  ',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: '₹4000 - ₹7500 (375) ',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
                SizedBox(width: 11),
                CommonContainerWidget.container(
                  text: '₹7500 - ₹10500(145) ',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: '₹10500 - ₹1500(85)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: '₹15000 - ₹30000(52)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: '₹30000+(85)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
              ],
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: 'DONE',
              onTap: () {},
              buttonColor: AppColors.redCA0,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
}
