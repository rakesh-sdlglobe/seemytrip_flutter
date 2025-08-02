import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class PriceBreakUpScreen extends StatelessWidget {
  PriceBreakUpScreen({Key? key}) : super(key: key);

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
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: "Price Breakup",
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
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Lists.priceBreakUpList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.priceBreakUpList[index]["text1"],
                            color: black2E2,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.priceBreakUpList[index]["text2"],
                            color: black2E2,
                            fontSize: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(color: greyE8E, thickness: 1),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 60,
                  width: Get.width,
                  color: black2E2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: "₹ 6,790",
                                  color: white,
                                  fontSize: 16,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "For 1 traveller",
                                  color: white,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                // Get.bottomSheet(
                                //   PriceBreakUpScreen(),
                                //   backgroundColor: Colors.transparent,
                                //   isScrollControlled: true,
                                // );
                              },
                              child: SvgPicture.asset(info),
                            ),
                          ],
                        ),
                        MaterialButton(
                          onPressed: () {
                            // Get.to(() => FareBreakUpScreen1());
                          },
                          height: 40,
                          minWidth: 140,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: redCA0,
                          child: CommonTextWidget.PoppinsSemiBold(
                            fontSize: 16,
                            text: "CONTINUE",
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
