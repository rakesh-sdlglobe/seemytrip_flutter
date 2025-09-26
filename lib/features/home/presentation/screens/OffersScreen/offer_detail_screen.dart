import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class OfferDetailScreen extends StatelessWidget {
  OfferDetailScreen({Key? key}) : super(key: key);

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
          text: 'Offers',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(offerDetailImage1, height: 175, width: Get.width),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: CommonTextWidget.PoppinsRegular(
                  text: 'Book Simply delightful stays now for your next ' 
                      'vacation. choose from 100+ Radisson Hotel ' 
                      'across 60+ cities in India with:',
                  color: AppColors.black2E2,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(offerDetailImage2,
                    height: 290, width: Get.width),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonButtonWidget.button(
                  buttonColor: AppColors.redCA0,
                  onTap: () {},
                  text: 'BOOK NOW',
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
}
