import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../../shared/constants/images.dart';

class ReferralScreen extends StatelessWidget {
  ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
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
              child: Icon(Icons.arrow_back, color: AppColors.black2E2, size: 20),
            ),
            SizedBox(height: 25),
            Image.asset(referralImage),
            SizedBox(height: 30),
            CommonTextWidget.PoppinsSemiBold(
              text: 'Enter Referral Code',
              color: AppColors.black2E2,
              fontSize: 20,
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              cursorColor: AppColors.black2E2,
              // controller: searchController,
              style: TextStyle(
                color: AppColors.black2E2,
                fontSize: 14,
                fontFamily: FontFamily.PoppinsRegular,
              ),
              decoration: InputDecoration(
                hintText: "Country Name or Code",
                hintStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontFamily: FontFamily.PoppinsRegular,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: "APPLY",
                    color: AppColors.redCA0,
                    fontSize: 18,
                  ),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.zero,
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
}
