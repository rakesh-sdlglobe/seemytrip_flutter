import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/SelectPaymentMethodScreen/fare_breakUp_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';

class PayByCardScreen extends StatelessWidget {
  PayByCardScreen({Key? key}) : super(key: key);
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameOnCardController = TextEditingController();
  final TextEditingController expiryMonthController = TextEditingController();
  final TextEditingController expiryYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Select Payment Mode",
          color: white,
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
                child: CommonTextFieldWidget.TextFormField3(
                  hintText: "Card Number",
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextFieldWidget.TextFormField3(
                  hintText: "Name on Card",
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
                      child: CommonTextFieldWidget.TextFormField9(
                        hintText: "Expiry MM",
                        controller: expiryMonthController,
                        keyboardType: TextInputType.text,
                        suffixIcon: Icon(Icons.arrow_drop_down_outlined,
                            color: grey969),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextFieldWidget.TextFormField9(
                        hintText: "Expiry YY",
                        controller: expiryYearController,
                        keyboardType: TextInputType.text,
                        suffixIcon: Icon(Icons.arrow_drop_down_outlined,
                            color: grey969),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextFieldWidget.TextFormField9(
                        hintText: "CVV",
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
                  color: black2E2,
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
                                text: "₹ 5,950 ",
                                style: TextStyle(
                                  fontFamily: FontFamily.PoppinsSemiBold,
                                  fontSize: 16,
                                  color: white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Due now ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: FontFamily.PoppinsMedium,
                                        color: grey8E8),
                                  ),
                                ],
                              ),
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: "Convenience Fee added",
                              color: grey8E8,
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
}
