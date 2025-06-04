import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/SelectPaymentMethodScreen/fare_breakUp_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/common_textfeild_widget.dart';

class PayByUpiScreen extends StatelessWidget {
  PayByUpiScreen({Key? key}) : super(key: key);
  final TextEditingController upiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          text: "Pay by UPI",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            CommonTextWidget.PoppinsMedium(
              text: "Enter virtual Payment Address (VPA)",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 33),
              child: CommonTextWidget.PoppinsRegular(
                text: "You will receive payment request on your bank app",
                color: grey717,
                fontSize: 12,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 33),
              child: CommonTextFieldWidget.TextFormField3(
                hintText: "eg: username@bank",
                controller: upiController,
                keyboardType: TextInputType.text,
              ),
            ),
            Spacer(),
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
    );
  }
}
