import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/font_family.dart';

class SearchPickUpAreaScreen extends StatelessWidget {
  SearchPickUpAreaScreen({Key? key}) : super(key: key);
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
                    color: AppColors.grey515.withOpacity(0.25),
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
                  hintText: 'Search Pickup Area',
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
            Row(
              children: [
                Icon(Icons.my_location,color: AppColors.redFD3),
                SizedBox(width: 12),
                CommonTextWidget.PoppinsRegular(
                  color: AppColors.black2E2,
                  text: 'Use current Location',
                  fontSize: 14,
                ),
              ],
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: 'SEARCH',
              buttonColor: AppColors.redCA0,
              onTap: () {
                // Get.to(() => CabTerminalScreen1());
              },
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
}
