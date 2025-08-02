import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/common_textfeild_widget.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class ContactInformationScreen extends StatelessWidget {
  ContactInformationScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) => Padding(
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
                    CommonTextFieldWidget(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    SizedBox(height: 20),
                    CommonTextFieldWidget(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
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
                  ]),
            ),
          ),
        ),
      ));
}
