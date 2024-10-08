// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class FareBreakUpScreen extends StatelessWidget {
  FareBreakUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 350),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: redCA0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, color: white, size: 20),
                    ),
                    CommonTextWidget.PoppinsMedium(
                      text: "Fare Breakup",
                      color: white,
                      fontSize: 18,
                    ),
                    SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: "Convenience Fee",
                    color: black2E2,
                    fontSize: 14,
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: "₹ 299",
                    color: black2E2,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(color: greyE8E, thickness: 1),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: "Fare",
                    color: black2E2,
                    fontSize: 14,
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: "₹ 5,057",
                    color: black2E2,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(color: greyE8E, thickness: 10),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: "DUE NOW",
                        color: black2E2,
                        fontSize: 18,
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: "*Prices inclusive of GST wherever indicated",
                        color: grey717,
                        fontSize: 10,
                      ),
                    ],
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: "₹ 5,057",
                    color: black2E2,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
