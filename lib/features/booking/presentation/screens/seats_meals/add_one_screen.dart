import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class AddOneScreen extends StatelessWidget {
  AddOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              color: redF9E.withOpacity(0.75),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 38, left: 24, right: 24, bottom: 15),
                child: CommonTextWidget.PoppinsRegular(
                  text: "Get more for less!\n "
                      "Exclusive services at fab\n "
                      "Prices",
                  color: black2E2,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 18),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Travel smart with You 1st",
                    color: black2E2,
                    fontSize: 16,
                  ),
                  Image.asset(spicejet, height: 30, width: 30),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: greyE8E, thickness: 1),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsRegular(
                text: "Skip the queue with priority check-in at dedicated "
                    "counters, priority boarding and get your bag(s) "
                    "before anyone else!",
                color: black2E2,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: "Benefits",
                color: grey717,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 135,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), color: redFAE),
                    child: Center(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Priority Check-in",
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 40,
                    width: 135,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), color: redFAE),
                    child: Center(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Priority Boarding",
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "₹ 399",
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsSemiBold,
                        fontSize: 14,
                        color: black2E2,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " (18% GST included)",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.PoppinsRegular,
                              color: grey717),
                        ),
                      ],
                    ),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "+ADD",
                    color: redCA0,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Image.asset(virus, height: 25, width: 25),
                  SizedBox(width: 25),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Covid 19 package",
                    color: black2E2,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: greyE8E, thickness: 1),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                text: TextSpan(
                  text: "Now travel worry free with Rs. 2,00,000 hospitalisation cover for ant COVID-19 variant and protect yourself from financial woes. valid for 6 days from trip date. TnC Apply",
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsRegular,
                    fontSize: 12,
                    color: black2E2,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " View all benefits",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.PoppinsRegular,
                          color: redCA0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "₹ 399",
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsSemiBold,
                        fontSize: 14,
                        color: black2E2,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " (18% GST included)",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.PoppinsRegular,
                              color: grey717),
                        ),
                      ],
                    ),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "+ADD",
                    color: redCA0,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 130),
          ],
        ),
      ),
    );
  }
}
