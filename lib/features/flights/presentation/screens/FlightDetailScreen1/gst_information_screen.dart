import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';

class GstInformationScreen extends StatelessWidget {
   GstInformationScreen({Key? key}) : super(key: key);
   final TextEditingController companyNameController = TextEditingController();
   final TextEditingController registerNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) => Padding(
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
                    text: 'GST Information',
                    color: black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 35),
                  CommonTextFieldWidget(
                    keyboardType: TextInputType.name,
                    controller: companyNameController,
                    hintText: 'Company Name',
                  ),
                  SizedBox(height: 20),
                  CommonTextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: registerNumberController,
                    hintText: 'Registration No',
                  ),
                  SizedBox(height: 60),
                  CommonButtonWidget.button(
                    onTap: (){
                      Get.back();
                    },
                    buttonColor: redCA0,
                    text: 'CONFIRM',
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
