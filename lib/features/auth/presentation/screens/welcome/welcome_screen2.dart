import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import '../../controllers/welcome2_controller.dart';
import '../login_screen.dart';

class WelcomeScreen2 extends StatelessWidget {
  WelcomeScreen2({Key? key}) : super(key: key);

  // Add language list
  final List<Map<String, String>> languageList = [
    {"name": "English", "code": "en", "native": "English"},
    {"name": "हिन्दी", "code": "hi", "native": "Hindi"},
    {"name": "தமிழ்", "code": "ta", "native": "Tamil"},
    {"name": "ಕನ್ನಡ", "code": "kn", "native": "Kannada"},
    {"name": "తెలుగు", "code": "te", "native": "Telugu"},
    {"name": "ଓଡ଼ିଆ", "code": "or", "native": "Odia"},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Top Image Container
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
                              text: 'SKIP',
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Welcome',
                            color: AppColors.white,
                            fontSize: 35,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: 'Select your Language',
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: 'You can also change language in App ' 'Settings after singning in',
                            color: AppColors.greyCAC,
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

          // Scrollable Content
          Padding(
            padding: EdgeInsets.only(top: 320),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: AppColors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 100, // Added extra padding for button
                ),
                child: GetBuilder<Welcome2Controller>(
                  init: Welcome2Controller(),
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: languageList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        onTap: () {
                          controller.onIndexChange(index);
                          Get.updateLocale(Locale(languageList[index]["code"]!));
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: controller.selectedIndex == index
                                    ? AppColors.redCA0
                                    : AppColors.greyB9B,
                                width: 1),
                            color: controller.selectedIndex == index
                                ? AppColors.redF9E
                                : AppColors.white,
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
                                      text: languageList[index]["name"]!,
                                      color: AppColors.black2E2,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: languageList[index]["native"]!,
                                  color: controller.selectedIndex == index
                                      ? AppColors.redCA0
                                      : AppColors.greyC8C,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Fixed Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CommonButtonWidget.button(
                text: 'CONTINUE',
                buttonColor: AppColors.redCA0,
                onTap: () {
                  Get.to(() => LogInScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
}
