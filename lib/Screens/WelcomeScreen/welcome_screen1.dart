import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/Screens/WelcomeScreen/welcome_screen2.dart';

class WelcomeScreen1 extends StatefulWidget {
  WelcomeScreen1({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen1> createState() => _WelcomeScreen1State();
}

class _WelcomeScreen1State extends State<WelcomeScreen1> {
  PageController pageController = PageController(initialPage: 0);
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: Lists.welcomeList.length,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) {
              setState(
                () {
                  index = i;
                },
              );
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 30, top: 140, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 170,
                      child: SvgPicture.asset(
                        Lists.welcomeList[index]["image"],
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 100),
                    CommonTextWidget.PoppinsMedium(
                      text: Lists.welcomeList[index]["text"],
                      color: black2E2,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: CommonTextWidget.PoppinsRegular(
                        text: Lists.welcomeList[index]["description"],
                        color: grey717,
                        fontSize: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                Lists.welcomeList.length,
                (position) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == position ? black2E2 : greyC7C,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 90),
            child: CommonButtonWidget.button(
              onTap: () {
                index == 2
                    ? Get.to(() => WelcomeScreen2())
                    : pageController.nextPage(
                        duration: 300.milliseconds, curve: Curves.ease);
              },
              buttonColor: redCA0,
              text: "NEXT",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: InkWell(
              onTap: () {
                Get.to(() => WelcomeScreen2());
              },
              child: CommonTextWidget.PoppinsSemiBold(
                text: "Skip",
                color: greyC7C,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
