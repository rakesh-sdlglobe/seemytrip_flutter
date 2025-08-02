import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/booking/presentation/screens/payment/fare_breakUp_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  SelectPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E.withOpacity(0.75),
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Select Payment Mode",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "New Delhi - Mumbai",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: "Departure Thu, 29 Sep",
                            color: grey717,
                            fontSize: 12,
                          ),
                          SizedBox(height: 8),
                          CommonTextWidget.PoppinsMedium(
                            text: "1)JohnDoe",
                            color: black2E2,
                            fontSize: 12,
                          ),
                          SizedBox(height: 8),
                          Divider(color: greyE8E, thickness: 1),
                          SizedBox(height: 10),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                Image.asset(spicejet, height: 30, width: 30),
                            title: CommonTextWidget.PoppinsMedium(
                              text: "DEL - BOM",
                              color: black2E2,
                              fontSize: 14,
                            ),
                            subtitle: CommonTextWidget.PoppinsRegular(
                              text: "Thu Sep 29 | 07:55 - 09:35",
                              color: black2E2,
                              fontSize: 14,
                            ),
                            trailing: CommonTextWidget.PoppinsRegular(
                              text: "Non Stop",
                              color: grey717,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsSemiBold(
                          text: "Other pay options",
                          color: black2E2,
                          fontSize: 16,
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: white,
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: Lists.selectPaymentMethodList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Column(
                              children: [
                                ListTile(
                                  onTap: Lists.selectPaymentMethodList[index]
                                      ["onTap"],
                                  horizontalTitleGap: -2,
                                  leading: Image.asset(
                                      Lists.selectPaymentMethodList[index]
                                          ["image"],
                                      height: 25,
                                      width: 25),
                                  title: CommonTextWidget.PoppinsMedium(
                                    text: Lists.selectPaymentMethodList[index]
                                        ["text1"],
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  subtitle: CommonTextWidget.PoppinsRegular(
                                    text: Lists.selectPaymentMethodList[index]
                                        ["text2"],
                                    color: black2E2,
                                    fontSize: 12,
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: redCA0),
                                ),
                                index == 3
                                    ? SizedBox.shrink()
                                    : Divider(color: greyE8E, thickness: 1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        text:
                            "By continuing to pay, I understand and agree with the ",
                        style: TextStyle(
                          fontFamily: FontFamily.PoppinsRegular,
                          fontSize: 12,
                          color: black2E2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Privacy Policy, ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: redCA0),
                          ),
                          TextSpan(
                            text: "the ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: black2E2),
                          ),
                          TextSpan(
                            text: "User Agreement ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: redCA0),
                          ),
                          TextSpan(
                            text: "and ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: black2E2),
                          ),
                          TextSpan(
                            text: "Terms of Service ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: redCA0),
                          ),
                          TextSpan(
                            text: "of MakeYourTrip. ",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                                color: black2E2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 65,
                width: Get.width,
                color: black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "₹ 5,950 ",
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsSemiBold,
                                fontSize: 16,
                                color: white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Due now ",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: FontFamily.PoppinsMedium,
                                      color: grey8E8),
                                ),
                              ],
                            ),
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: "Convenience Fee added",
                            color: grey8E8,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            FareBreakUpScreen(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        },
                        child: SvgPicture.asset(info),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
