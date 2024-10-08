import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Controller/otp_controller.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/full_name_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key}) : super(key: key);

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final OtpController otpController = Get.put(OtpController());

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: black2E2, size: 20),
            ),
            SizedBox(height: 30),
            CommonTextWidget.PoppinsSemiBold(
              text: "Verify your Mobile Number",
              color: black2E2,
              fontSize: 20,
            ),
            CommonTextWidget.PoppinsRegular(
              text: "OTP has been send to MOBILE",
              color: black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 35),
            CommonTextWidget.PoppinsMedium(
              text: "Enter OTP",
              color: redCA0,
              fontSize: 17,
            ),
            SizedBox(height: 15),
            Container(
              color: white,
              child: PinPut(
                fieldsCount: 5,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    otpController.isTextEmpty.value = true;
                  } else {
                    otpController.isTextEmpty.value = false;
                  }
                },
                textStyle: TextStyle(
                  fontFamily: FontFamily.PoppinsSemiBold,
                  fontSize: 18,
                  color: black2E2,
                ),
                cursorColor: black2E2,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(color: redCA0, width: 1.5),
                ),
                selectedFieldDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(color: redCA0, width: 1.5),
                ),
                followingFieldDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(color: greyC7C, width: 1.5),
                ),
                disabledDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(color: greyC7C, width: 1),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget.PoppinsRegular(
                  text: "Auto fetching OTP send via SMS",
                  color: grey717,
                  fontSize: 14,
                ),
                CommonTextWidget.PoppinsRegular(
                  text: "29s",
                  color: black2E2,
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: CommonTextWidget.PoppinsMedium(
                text: "Resend OTP",
                color: redCA0.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              onTap: () {
                Get.to(() => FullNameScreen());
              },
              buttonColor: otpController.isTextEmpty.isFalse ? greyD8D : redCA0,
              text: "SUBMIT",
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
