import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/login_controller.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/otp_screen.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:makeyourtripapp/Screens/ReferralScreen/refferal_screen.dart';
import 'package:makeyourtripapp/Screens/SelectCountryScreen/select_country_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);
  final TextEditingController numberController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: 280,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(logInImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Image.asset(welcome2Canvas,
                    width: Get.width, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 40),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => NavigationScreen());
                            },
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: "SKIP",
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Join the club of 10 crore+ "
                                "happy travellers",
                            color: white,
                            fontSize: 22,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 245),
            child: Container(
              // height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: white,
              ),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CommonTextWidget.PoppinsMedium(
                          text: "Use Mobile Number or Email to Login/Signup",
                          color: grey929,
                          fontSize: 14,
                        ),
                        SizedBox(height: 35),
                        CommonTextFieldWidget.TextFormField1(
                          hintText: "Enter Mobile No./Email",
                          keyboardType: TextInputType.text,
                          controller: numberController,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => SelectCountryScreen());
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(indianFlagImage,
                                      height: 23, width: 23),
                                  SizedBox(width: 4),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "+91",
                                    color: grey929,
                                    fontSize: 16,
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: grey929,
                                      thickness: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                              ),
                            ),
                          ),
                          onChange: (value) {
                            if (value.isNotEmpty) {
                              loginController.isTextEmpty.value = true;
                            } else {
                              loginController.isTextEmpty.value = false;
                            }
                          },
                        ),
                        SizedBox(height: 35),
                        Obx(
                          () => CommonButtonWidget.button(
                            onTap: () {
                              Get.to(() => OtpScreen());
                            },
                            buttonColor: loginController.isTextEmpty.isFalse
                                ? greyD8D
                                : redCA0,
                            text: "CONTINUE",
                          ),
                        ),
                        SizedBox(height: 55),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  width: Get.width,
                                  color: greyD8D,
                                ),
                              ),
                              SizedBox(width: 15),
                              CommonTextWidget.PoppinsMedium(
                                text: "or Login / Signup with",
                                color: grey929,
                                fontSize: 12,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  width: Get.width,
                                  color: greyD8D,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 55),
                        Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: greyD8D, width: 1),
                            color: white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(googleImage),
                                CommonTextWidget.PoppinsMedium(
                                  text: "Continue with Google",
                                  color: grey717,
                                  fontSize: 16,
                                ),
                                Image.asset(googleImage, color: white),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Get.to(() => ReferralScreen());
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Have a ",
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsMedium,
                                fontSize: 14,
                                color: grey929,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Referral Code?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      color: redCA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "By proceeding, you agree to MakeYourTrip’s ",
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsRegular,
                              fontSize: 10,
                              color: grey929,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Privacy Policy. User Agreement. T&Cs ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: redCA0),
                              ),
                              TextSpan(
                                text: "as well Mobile connect’s ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsRegular,
                                    color: grey929),
                              ),
                              TextSpan(
                                text: "T&Cs",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: redCA0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
