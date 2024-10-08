import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

class ContactInformationScreen extends StatelessWidget {
  ContactInformationScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 350),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Contact information",
                    color: black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsRegular(
                    text:
                        "Your ticket and flights information will be send here.",
                    color: grey717,
                    fontSize: 16,
                  ),
                  SizedBox(height: 25),
                  CommonTextFieldWidget.TextFormField4(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    cursorColor: black2E2,
                    controller: phoneController,
                    style: TextStyle(
                      color: black2E2,
                      fontSize: 14,
                      fontFamily: FontFamily.PoppinsRegular,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: InkWell(
                          onTap: () {
                            // Get.to(() => SelectCountryScreen());
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
                      filled: true,
                      fillColor: white,
                      contentPadding: EdgeInsets.only(left: 12),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: greyE2E, width: 1)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: greyE2E, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: greyE2E, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: greyE2E, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: greyE2E, width: 1)),
                    ),
                  ),
                  SizedBox(height: 60),
                  CommonButtonWidget.button(
                    onTap: () {
                      Get.back();
                    },
                    buttonColor: redCA0,
                    text: "CONFIRM",
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
