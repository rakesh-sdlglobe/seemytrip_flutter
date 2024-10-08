import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Controller/full_name_controller.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class FullNameScreen extends StatelessWidget {
  FullNameScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final FullNameController fullNameController = Get.put(FullNameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
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
              text: "Welcome Aboard!",
              color: black2E2,
              fontSize: 20,
            ),
            CommonTextWidget.PoppinsRegular(
              text: "Complete your profile to make your booking faster.",
              color: black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 35),
            TextFormField(
              onChanged:(value) {
                if (value.isNotEmpty) {
                  fullNameController.isTextEmpty.value = true;
                } else {
                  fullNameController.isTextEmpty.value = false;
                }
              },
              keyboardType: TextInputType.text,
              cursorColor: black2E2,
              controller: nameController,
              style: TextStyle(
                color: black2E2,
                fontSize: 14,
                fontFamily: FontFamily.PoppinsRegular,
              ),
              decoration: InputDecoration(
                hintText: "Full Name",
                hintStyle: TextStyle(
                  color: grey929,
                  fontSize: 16,
                  fontFamily: FontFamily.PoppinsMedium,
                ),
                filled: true,
                fillColor: white,
                contentPadding: EdgeInsets.only(left: 22),
                disabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
              ),
            ),
            Spacer(),
            Obx(
                  () => CommonButtonWidget.button(
                onTap: () {
                  Get.to(() => NavigationScreen());
                },
                buttonColor:
                fullNameController.isTextEmpty.isFalse ? greyD8D : redCA0,
                text: "SUBMIT",
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
