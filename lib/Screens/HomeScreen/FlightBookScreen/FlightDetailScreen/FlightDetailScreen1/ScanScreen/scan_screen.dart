import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class ScanScreen extends StatelessWidget {
  ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 407,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              CommonTextWidget.PoppinsSemiBold(
                text: "Scan to auto-fill this form!",
                color: black2E2,
                fontSize: 18,
              ),
              SizedBox(height: 10),
              CommonTextWidget.PoppinsRegular(
                text: "Your experience would be mediocre without "
                    "the permissions we need.",
                color: grey717,
                fontSize: 16,
              ),
              SizedBox(height: 30),
              Center(
                child: SvgPicture.asset(circuleCheckImage),
              ),
              SizedBox(height: 30),
              CommonTextWidget.PoppinsRegular(
                text:
                    "With this, you will be able to doenload your tickets & upload images to submit reviews on our app.",
                color: grey717,
                fontSize: 16,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonTextWidget.PoppinsMedium(
                      text: "NO, NOT NOW",
                      color: redCA0,
                      fontSize: 16,
                    ),
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: "YES, GO AHEAD",
                    color: redCA0,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
