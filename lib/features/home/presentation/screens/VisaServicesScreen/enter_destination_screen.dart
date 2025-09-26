import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/main.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../shared/constants/font_family.dart';

class EnterDestinationScreen extends StatelessWidget {
  EnterDestinationScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 65),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey515.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: AppColors.black2E2,
                controller: searchController,
                style: TextStyle(
                  color: AppColors.black2E2,
                  fontSize: 14,
                  fontFamily: FontFamily.PoppinsRegular,
                ),
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: AppColors.grey717),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: CommonTextWidget.PoppinsMedium(
                      color: AppColors.redCA0,
                      text: 'Clear',
                      fontSize: 12,
                    ),
                  ),
                  hintText: 'Enter Destination',
                  hintStyle: TextStyle(
                    color: AppColors.greyA1A,
                    fontSize: 15,
                    fontFamily: FontFamily.PoppinsRegular,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.only(left: 12),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.white, width: 0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.white, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.white, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.white, width: 0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.white, width: 0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: Lists.startFromList.length,
                itemBuilder: (context, index) => Padding(
                  padding:  EdgeInsets.only(bottom: 24),
                  child: CommonTextWidget.PoppinsRegular(
                    color: AppColors.grey717,
                    text: Lists.startFromList[index],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
