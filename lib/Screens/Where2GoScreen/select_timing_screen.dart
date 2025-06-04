import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class SelectTimingScreen extends StatelessWidget {
  SelectTimingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 300),
      child: Container(
        width: Get.width,
        color: white,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: "Selected Timing",
                        color: black2E2,
                        fontSize: 18,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close, color: black2E2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: greyE8E, thickness: 1),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Image.asset(selectTimingImage, height: 36, width: 100),
                ),
                SizedBox(height: 20),
                Divider(color: greyE8E, thickness: 1),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: "Per Person",
                        color: grey717,
                        fontSize: 14,
                      ),
                      Row(
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "₹ 1,568",
                            color: black2E2,
                            fontSize: 16,
                          ),
                          SizedBox(width: 20),
                          Container(
                            height: 37,
                            width: 98,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: greyB3B, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.remove, color: grey717, size: 10),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "01",
                                    color: black2E2,
                                    fontSize: 18,
                                  ),
                                  Icon(Icons.add, color: grey717, size: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonButtonWidget.button(
                    text: "CONTINUE",
                    onTap: () {},
                    buttonColor: redCA0,
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
