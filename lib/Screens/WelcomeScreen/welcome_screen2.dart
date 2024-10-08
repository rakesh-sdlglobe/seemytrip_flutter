import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/welcome2_controller.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/login_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class WelcomeScreen2 extends StatelessWidget {
  WelcomeScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: 350,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(welcome2Image),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Image.asset(welcome2Canvas,
                    width: Get.width, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 40),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => LogInScreen());
                            },
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: "SKIP",
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Welcome",
                            color: white,
                            fontSize: 35,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: "Select your Language",
                            color: white,
                            fontSize: 20,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: "You can also change language in App "
                                "Settings after singning in",
                            color: greyCAC,
                            fontSize: 14,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 320),
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: white,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 70),
                child: Column(
                  children: [
                    GetBuilder<Welcome2Controller>(
                      init: Welcome2Controller(),
                      builder: (controller) => ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Lists.welcome2List.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: InkWell(
                            onTap: () {
                              controller.onIndexChange(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: controller.selectedIndex == index
                                        ? redCA0
                                        : greyB9B,
                                    width: 1),
                                color: controller.selectedIndex == index
                                    ? redF9E
                                    : white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            controller.selectedIndex == index
                                                ? selectedIcon
                                                : unSelectedIcon),
                                        SizedBox(width: 20),
                                        CommonTextWidget.PoppinsMedium(
                                          text: Lists.welcome2List[index]
                                              ["text1"],
                                          color: black2E2,
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: Lists.welcome2List[index]["text2"],
                                      color: controller.selectedIndex == index
                                          ? redCA0
                                          : greyC8C,
                                      fontSize: 29,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    CommonButtonWidget.button(
                      text: "CONTINUE",
                      buttonColor: redCA0,
                      onTap: () {
                        Get.to(() => LogInScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
