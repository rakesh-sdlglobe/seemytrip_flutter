import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

class GstInformationScreen extends StatelessWidget {
   GstInformationScreen({Key? key}) : super(key: key);
   final TextEditingController companyNameController = TextEditingController();
   final TextEditingController registerNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 350),
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
                    text: "GST Information",
                    color: black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 35),
                  CommonTextFieldWidget.TextFormField4(
                    keyboardType: TextInputType.name,
                    controller: companyNameController,
                    hintText: "Company Name",
                  ),
                  SizedBox(height: 20),
                  CommonTextFieldWidget.TextFormField4(
                    keyboardType: TextInputType.number,
                    controller: registerNumberController,
                    hintText: "Registration No",
                  ),
                  SizedBox(height: 60),
                  CommonButtonWidget.button(
                    onTap: (){
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
