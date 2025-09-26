import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/common_container_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';

class PopularFilterScreen extends StatelessWidget {
  PopularFilterScreen({Key? key}) : super(key: key);

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
          text: 'Popular filters',
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
              text: 'Suggested For You',
              color: AppColors.black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: 'Reted Excellent by Travellers(256)',
              borderColor: AppColors.redCA0,
              textColor: AppColors.redCA0,
             ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: '3 Star Properties(253)',
                  borderColor: AppColors.redCA0,
                  textColor: AppColors.redCA0,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: 'North Goa',
                  borderColor: AppColors.redCA0,
                  textColor: AppColors.redCA0,
                ),
              ],
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: 'Rated Excellent on Value for Money(458)',
              borderColor: AppColors.white,
              textColor: AppColors.grey717,
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: 'MMT ValueStay - Top Rated Affordable(25)',
              borderColor: AppColors.white,
              textColor: AppColors.grey717,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: 'Beachfont(569)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: 'Free Breakfast(526)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: 'Entire Property(454)',
                  borderColor: AppColors.white,
                  textColor: AppColors.grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: 'Villas(458)',
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
