import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class ReferralScreen extends StatelessWidget {
  ReferralScreen({Key? key}) : super(key: key);

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
            SizedBox(height: 60),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: black2E2, size: 20),
            ),
            SizedBox(height: 25),
            Image.asset(referralImage),
            SizedBox(height: 30),
            CommonTextWidget.PoppinsSemiBold(
              text: "Enter Referral Code",
              color: black2E2,
              fontSize: 20,
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              cursorColor: black2E2,
              // controller: searchController,
              style: TextStyle(
                color: black2E2,
                fontSize: 14,
                fontFamily: FontFamily.PoppinsRegular,
              ),
              decoration: InputDecoration(
                hintText: "Country Name or Code",
                hintStyle: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontFamily: FontFamily.PoppinsRegular,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: "APPLY",
                    color: redCA0,
                    fontSize: 18,
                  ),
                ),
                filled: true,
                fillColor: white,
                contentPadding: EdgeInsets.zero,
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
