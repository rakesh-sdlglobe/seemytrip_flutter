import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../../shared/constants/images.dart';
import 'fare_breakUp_screen.dart';

class PayByCardScreen extends StatelessWidget {
  PayByCardScreen({Key? key}) : super(key: key);
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameOnCardController = TextEditingController();
  final TextEditingController expiryMonthController = TextEditingController();
  final TextEditingController expiryYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
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
          text: 'Select Payment Mode',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextFieldWidget(
                  hintText: 'Card Number',
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextFieldWidget(
                  hintText: 'Name on Card',
                  controller: nameOnCardController,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        hintText: 'Expiry MM',
                        controller: expiryMonthController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(Icons.arrow_drop_down_outlined,
                            color: AppColors.grey969),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextFieldWidget(
                        hintText: 'Expiry YY',
                        controller: expiryYearController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(Icons.arrow_drop_down_outlined,
                            color: AppColors.grey969),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextFieldWidget(
                        hintText: 'CVV',
                        controller: cvvController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 298),
              // Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55),
                child: Image.asset(paymentMethodBottomImage),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 65,
                  width: Get.width,
                  color: AppColors.black2E2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '₹ 5,950 ',
                                style: TextStyle(
                                  fontFamily: FontFamily.PoppinsSemiBold,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Due now ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: FontFamily.PoppinsMedium,
                                        color: AppColors.grey8E8),
                                  ),
                                ],
                              ),
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: 'Convenience Fee added',
                              color: AppColors.grey8E8,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              FareBreakUpScreen(),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                          child: SvgPicture.asset(info),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
}
