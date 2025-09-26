import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/hotels/presentation/screens/select_room_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class RatePlanDetailScreen extends StatelessWidget {
  RatePlanDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Rate Plan Details',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          Image.asset(ratePlanDetail),
          Spacer(),
          Container(
            width: Get.width,
            color: AppColors.black2E2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: '₹ 7,950',
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: '+ ₹870 taxes & service fees',
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: 'Per Night (2 Adults)',
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(()=>SelectRoomScreen());
                    },
                    height: 40,
                    minWidth: 140,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: AppColors.redCA0,
                    child: CommonTextWidget.PoppinsSemiBold(
                      fontSize: 16,
                      text: 'SELECT ROOM',
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
}
