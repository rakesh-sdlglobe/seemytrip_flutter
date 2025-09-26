import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

RxBool seatSelected = false.obs;
seatsRow({index, image1, image2, image3, image4, image5, image6}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CommonTextWidget.PoppinsMedium(
        text: index,
        fontSize: 16,
        color: AppColors.grey717,
      ),
      Column(
        children: [
          index == '1'
              ? Row(
                  children: [
                    CommonTextWidget.PoppinsMedium(
                      text: 'A',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                    SizedBox(width: 28),
                    CommonTextWidget.PoppinsMedium(
                      text: 'B',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                    SizedBox(width: 28),
                    CommonTextWidget.PoppinsMedium(
                      text: 'C',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                  ],
                )
              : SizedBox(),
          Row(
            children: [
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image1,
                  height: 31,
                  width: 31,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image2,
                  height: 31,
                  width: 31,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image3,
                  height: 31,
                  width: 31,
                ),
              )
            ],
          ),
        ],
      ),
      Column(
        children: [
          index == '1'
              ? Row(
                  children: [
                    CommonTextWidget.PoppinsMedium(
                      text: 'D',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                    SizedBox(width: 28),
                    CommonTextWidget.PoppinsMedium(
                      text: 'E',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                    SizedBox(width: 28),
                    CommonTextWidget.PoppinsMedium(
                      text: 'F',
                      color: AppColors.grey717,
                      fontSize: 16.0,
                    ),
                  ],
                )
              : SizedBox(),
          Row(
            children: [
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image4,
                  height: 31,
                  width: 31,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image5,
                  height: 31,
                  width: 31,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Image.asset(
                  image6,
                  height: 31,
                  width: 31,
                ),
              )
            ],
          ),
        ],
      ),
      CommonTextWidget.PoppinsMedium(
        text: index,
        fontSize: 16,
        color: AppColors.grey717,
      )
    ],
  );

openBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      height: 258,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 25),
        child: Column(
          children: [
            CommonTextWidget.PoppinsMedium(
              text: 'Your Seats',
              fontSize: 25,
              color: AppColors.black2E2,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget.PoppinsMedium(
                  text: '7B',
                  color: AppColors.black2E2,
                  fontSize: 18.0,
                ),
                CommonTextWidget.PoppinsMedium(
                  text: '₹ 0',
                  fontSize: 18.0,
                ),
              ],
            ),
            SizedBox(height: 61),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    seatSelected.value = true;
                    Get.back();
                  },
                  child: CommonTextWidget.PoppinsSemiBold(
                    text: 'OKAY',
                    color: AppColors.redCA0,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
